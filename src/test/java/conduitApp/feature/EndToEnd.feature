@end
Feature: end-to-end API test suite for the ConduitApp 

Background: preconditions
    * def dataGenerator = Java.type('helpers.DataGenerator')
    Given url apiUrl 

Scenario: end-to-end API test
    # SignUp page 

    * def randomEmail = dataGenerator.getRandomNumber();
    * def randomName = dataGenerator.getRandomName();

    Given path 'users'
    Then request 
    """
    {
        "user": {
            "email": #(randomEmail),
            "password": "test@123",
            "username": #(randomName)
        }
    }
    """
    When method post
    Then status 201
    
    * match response.user contains
    """
    {
        "email": "#string",
        "username": "#string",
        "token": "#string"
    }
    
    """
    * match response.user.token != null
