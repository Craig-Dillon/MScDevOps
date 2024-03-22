using Microsoft.VisualStudio.TestTools.UnitTesting;
using BPCalculator;
using System;

namespace bpUnitTestProject
{
    [TestClass]
    public class UnitTest1
    {
        [TestMethod]
        public void TestLowBloodPressure()
        {
            BloodPressure bloodPressure = new BloodPressure() { Systolic = 80, Diastolic = 50 };
            Assert.AreEqual(BPCategory.Low, bloodPressure.Category);
        }

        [TestMethod]
        public void TestIdealBloodPressure()
        {
            BloodPressure bloodPressure = new BloodPressure() { Systolic = 110, Diastolic = 70 };
            Assert.AreEqual(BPCategory.Ideal, bloodPressure.Category);
        }

        [TestMethod]
        public void TestPreHighBloodPressure()
        {
            BloodPressure bloodPressure = new BloodPressure() { Systolic = 130, Diastolic = 85 };
            Assert.AreEqual(BPCategory.PreHigh, bloodPressure.Category);
        }

        [TestMethod]
        public void TestHighBloodPressure()
        {
            BloodPressure bloodPressure = new BloodPressure() { Systolic = 160, Diastolic = 95 };
            Assert.AreEqual(BPCategory.High, bloodPressure.Category);
        }

        [TestMethod]
        public void TestEmergencyBloodPressure()
        {
            BloodPressure bloodPressure = new BloodPressure() { Systolic = 185, Diastolic = 110 };
            Assert.AreEqual(BPCategory.Emergency, bloodPressure.Category);
        }

        [TestMethod]
        public void TestInvalidBloodPressure()
        {
            BloodPressure bloodPressure = new BloodPressure() { Systolic = 50, Diastolic = 130 };

            Assert.ThrowsException<InvalidOperationException>(() => bloodPressure.Category);
        }

        [TestMethod]
        public void TestMinimumValidBloodPressure()
        {
            BloodPressure bloodPressure = new BloodPressure() { Systolic = 70, Diastolic = 40 };
            Assert.AreEqual(BPCategory.Low, bloodPressure.Category);
        }

        [TestMethod]
        public void TestMaximumValidBloodPressure()
        {
            BloodPressure bloodPressure = new BloodPressure() { Systolic = 190, Diastolic = 120 };
            Assert.AreEqual(BPCategory.Emergency, bloodPressure.Category);
        }

        [TestMethod]
        public void TestUpperBoundaryBloodPressure()
        {
            BloodPressure bloodPressure = new BloodPressure() { Systolic = 180, Diastolic = 115 };
            Assert.AreEqual(BPCategory.Emergency, bloodPressure.Category);
        }

        [TestMethod]
        public void TestLowerBoundaryBloodPressure()
        {
            BloodPressure bloodPressure = new BloodPressure() { Systolic = 75, Diastolic = 45 };
            Assert.AreEqual(BPCategory.Low, bloodPressure.Category);
        }
    }
}
