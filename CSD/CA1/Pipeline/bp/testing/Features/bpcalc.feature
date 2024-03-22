Feature: Blood Pressure Calculator
    As a user
    I want to calculate blood pressure categories

    Scenario: Calculate Ideal Blood Pressure
        Given the systolic value is 120
        And the diastolic value is 80
        When I calculate the blood pressure category
        Then the category should be "Ideal"

    Scenario: Calculate Pre-High Blood Pressure
        Given the systolic value is 130
        And the diastolic value is 90
        When I calculate the blood pressure category
        Then the category should be "PreHigh"

    Scenario: Calculate High Blood Pressure
        Given the systolic value is 150
        And the diastolic value is 90
        When I calculate the blood pressure category
        Then the category should be "High"

    Scenario: Calculate Emergency Category
        Given the systolic value is 185
        And the diastolic value is 105
        When I calculate the blood pressure category
        Then the category should be "Emergency"