const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const mysql = require('mysql2');
const session = require('express-session');
const MemcachedStore = require('connect-memcached')(session);
const crypto = require('crypto');
const WebSocket = require('ws');
const fs = require('fs');
const https = require('https');

const app = express();
const port = 3001;

// Create HTTPS server
const server = https.createServer({
  cert: fs.readFileSync('certificate.pem'),
  key: fs.readFileSync('privatekey.pem')
}, app);

server.listen(port, function() {
  console.log(`Server listening at https://localhost:${port}`);
});

// Create WebSocket server using the HTTPS server
const wss = new WebSocket.Server({ server });

// Function to generate a random string of specified length
const generateRandomString = (length) => {
  return crypto.randomBytes(Math.ceil(length / 2))
    .toString('hex') 
    .slice(0, length); 
};

// Generate a random secret key
const secretKey = generateRandomString(32);
console.log('Generated Secret Key:', secretKey);

// MySQL connection
const db = mysql.createConnection({
  host: 'mysql-service.mysql.svc.cluster.local',
  port: '3306',
  user: 'root',
  password: 'verysecurepassword',
  database: 'cars_db'
});

db.connect(err => {
  if (err) {
    console.error('Error connecting to MySQL:', err);
    return;
  }
  console.log('Connected to MySQL database');
});

// Session management
app.use(session({
  secret: secretKey, // Use the generated secret key here
  resave: false,
  saveUninitialized: true,
  store: new MemcachedStore({
    hosts: ['memcached-service.memcached.svc.cluster.local:11211']
  })
}));


app.use(cors());

app.use(bodyParser.json());

// API endpoint to fetch cars
app.get('/api/cars', (req, res) => {
  const query = 'SELECT id, make, model, year, registration FROM cars'; 
  db.query(query, (err, result) => {
    if (err) {
      console.error('Error querying cars:', err);
      res.status(500).json({ error: 'Internal server error' });
      return;
    }
    res.json(result);
  });
});

// API endpoint to create a new car
app.post('/api/cars', (req, res) => {
  const { make, model, year, registration } = req.body;
  const query = 'INSERT INTO cars (make, model, year, registration) VALUES (?, ?, ?, ?)';
  db.query(query, [make, model, year, registration], (err, result) => {
    if (err) {
      console.error('Error creating car:', err);
      res.status(500).json({ error: 'Internal server error' });
      return;
    }
    res.json({ message: 'Car created successfully', carId: result.insertId });
  });
});

// WebSocket connection handling
wss.on('connection', (ws) => {
  console.log('WebSocket connection established');

  ws.on('message', (message) => {
    console.log('Received message:', message);
  });

  ws.send('WebSocket connection established');
});
