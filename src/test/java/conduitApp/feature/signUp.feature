Feature: Sign Up Page for new users

Background: Preconditions
        * def dataGenerator = Java.type('helpers.DataGenerator')
        Given url 'https://conduit-api.bondaracademy.com/api/'


@debug
Scenario: Sign Up

    # * def userdata = {"email":"Signuptest2@test.com","username":"Signuptest2"}
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
    And match response ==
    """
    {
    "user": {
        "id": '#number',
        "email": #(randomEmail),
        "username": #(randomName),
        "bio": null,
        "image": '#string',
        "token": '#string'
    }
}
    """