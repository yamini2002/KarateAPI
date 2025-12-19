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
    * def accessToken = response.user.token
    * print accessToken 
    * match response.user.email == randomEmail
    * match response.user.username == randomName
    * match response.user.token == accessToken
   
    * match response.user.token != null
    * match response.user.token != {}

    # SignUp page 
    Given path 'users/login'
    And request {"user":{"email":"yamini@test.com","password":"Test@123"}}
    When method post
    Then status 200
    
    * match response.user contains { token: '#string' }
    * def token = response.user.token

    # Token Validation
    # Get current user with valid token
    Given path 'user'
    And header Authorization = 'Token ' + token
    When method get
    Then status 200

    # Get current user with Missing token
    Given path 'user'
    When method get
    Then status 401

    # Get current user with Corrupted token
    Given path 'user'
    And header Authorization = token
    When method get
    Then status 401
