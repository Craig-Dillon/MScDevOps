import React, { useState, useEffect } from 'react';
import { createRoot } from 'react-dom/client';
import axios from 'axios';

function CreateCarForm() {
  const [make, setMake] = useState('');
  const [model, setModel] = useState('');
  const [year, setYear] = useState('');
  const [registration, setRegistration] = useState('');
  const [searchTerm, setSearchTerm] = useState('');
  const [searchResults, setSearchResults] = useState([]);

  useEffect(() => {
    handleSearch();
  }, [searchTerm]);

  const handleSubmit = async (e) => {
    e.preventDefault(); // Prevent default form submission behavior
    console.log('Submitting car:', { make, model, year, registration });
    try {
      await axios.post('https://backend:3001/api/cars', { make, model, year, registration });
      console.log('Car created successfully');
      setMake('');
      setModel('');
      setYear('');
      setRegistration('');
      handleSearch();
    } catch (error) {
      console.error('Error creating car:', error);
    }
  };

  const handleSearch = async () => {
    console.log('Searching for cars with term:', searchTerm);
    try {
      const response = await axios.get(`https://backend:3001/api/cars?search=${searchTerm}`);
      console.log('Search results:', response.data);
      setSearchResults(response.data);
    } catch (error) {
      console.error('Error searching cars:', error);
    }
  };

  return (
    <div>
      <h1>Car Database System V2</h1>
      <form onSubmit={handleSubmit}>
        <input type="text" placeholder="Make" value={make} onChange={(e) => setMake(e.target.value)} />
        <input type="text" placeholder="Model" value={model} onChange={(e) => setModel(e.target.value)} />
        <input type="text" placeholder="Year" value={year} onChange={(e) => setYear(e.target.value)} />
        <input type="text" placeholder="Registration" value={registration} onChange={(e) => setRegistration(e.target.value)} />
        <button type="submit">Submit</button>
      </form>
      <hr />
      <input type="text" placeholder="Search by make, model, year, or registration" value={searchTerm} onChange={(e) => setSearchTerm(e.target.value)} />
      <button onClick={handleSearch}>Search</button>
      <ul>
        {searchResults.map((car, index) => (
          <li key={index}>
            <strong>{car.make}</strong> - {car.model} ({car.year}) - {car.registration}
          </li>
        ))}
      </ul>
    </div>
  );
}

const root = createRoot(document.getElementById('root'));
root.render(<CreateCarForm />);

export default CreateCarForm;
