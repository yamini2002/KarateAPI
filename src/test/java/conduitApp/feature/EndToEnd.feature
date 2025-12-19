@end
Feature: end-to-end API test suite for the ConduitApp 

Background: preconditions
    * def dataGenerator = Java.type('helpers.DataGenerator')
    Given url apiUrl 

Scenario: end-to-end API test
    # SignUp page 

    # * def randomEmail = dataGenerator.getRandomNumber();
    # * def randomName = dataGenerator.getRandomName();
    # Given path 'users'
    # Then request 
    # """
    # {
    #     "user": {
    #         "email": #(randomEmail),
    #         "password": "test@123",
    #         "username": #(randomName)
    #     }
    # }
    # """
    # When method post
    # Then status 201
    # * def accessToken = response.user.token
    # * print accessToken 
    # * match response.user.email == randomEmail
    # * match response.user.username == randomName
    # * match response.user.token == accessToken
    # * match response.user.token != null
    # * match response.user.token != {}

    # SignUp page 
    Given path 'users/login'
    And request {"user":{"email":"yamini@test.com","password":"Test@123"}}
    When method post
    Then status 200
    
    * match response.user contains { token: '#string' }
    * def username = response.user.username
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
    And header Authorization = 'sdfg '+token
    When method get
    Then status 401

    #Create Article
    Given path 'articles'
    Given header Authorization = 'Token ' + token
    And request 
    """
        {
            "article": {
                "title": "Conduit App Testing",
                "description": "Conduit App ",
                "body": "aszfdcfhgbhkjnmk",
                "tagList": [
                    "@smoke",
                    "@regression",
                    "@sanity"
                ]
            }
        }
    """
    When method post
    Then status 201
    * match response.article.slug == '#string' 
    * match response.article.favoritesCount == 0
    * match response.article.favorited == false
    * match response.article.author.username == username
    
    * def SlugId = response.article.slug
    * def body = response.article.body
    * def description = response.article.description
    * def createdAt = response.article.createdAt
    * def authorName = response.article.author.username
    
    #Cross-Endpoint Data Consistency
    Given path 'articles', SlugId
    Given header Authorization = 'Token ' + token
    When method get
    Then status 200
    * match response.article.slug == SlugId
    * match response.article.createdAt == createdAt
    * match response.article.author.username == authorName

    # Given path 'articles'
    # Given header Authorization = 'Token ' + token
    # And param author = authorName
    # When method get
    # Then status 200
    # * match response.article.slug == SlugId
    # * match response.article.createdAt == createdAt
    # * match response.article.author.username == authorName

    # Update article
    Given path 'articles', SlugId
    Given header Authorization = 'Token ' + token
    And request 
    """
        {
            "article": {
                "body": "Testing the App"
            }
        }
    """
    When method put
    Then status 200

    * match response.article.slug == SlugId
    * def created = new Date(response.article.createdAt).getTime()
    * def updated = new Date(response.article.updatedAt).getTime()
    * assert updated > created

    # Verify Updated Data
    Given path 'articles', SlugId
    Given header Authorization = 'Token ' + token
    When method get
    Then status 200
    * match response.article.body != body
    * print response.article.body
    * match response.article.description == description

    #Delete 
    Given path 'articles',SlugId
    Given header Authorization = 'Token ' + token
    When method delete
    Then status 204