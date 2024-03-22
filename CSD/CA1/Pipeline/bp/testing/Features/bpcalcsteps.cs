using BPCalculator;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using TechTalk.SpecFlow;

[Binding]
public class BPCalculatorSteps
{
    private BloodPressure bloodPressure;
    private BPCategory actualCategory;

    [Given("the systolic value is (.*)")]
    public void GivenTheSystolicValueIs(int systolic)
    {
        bloodPressure = new BloodPressure { Systolic = systolic };
    }

    [Given("the diastolic value is (.*)")]
    public void GivenTheDiastolicValueIs(int diastolic)
    {
        bloodPressure.Diastolic = diastolic;
    }

    [When("I calculate the blood pressure category")]
    public void WhenICalculateTheBloodPressureCategory()
    {
        actualCategory = bloodPressure.Category;
    }

    [Then("the category should be \"(.*)\"")]
    public void ThenTheCategoryShouldBe(string expectedCategory)
    {
        Assert.AreEqual(expectedCategory, actualCategory.ToString());
    }
}
