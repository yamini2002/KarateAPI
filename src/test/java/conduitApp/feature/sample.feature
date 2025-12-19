@reg
Feature: Create and Delete
Background: Steps
  Given url apiUrl
#   * def tokenResponse = callonce read('classpath:helpers/Createtoken.feature') 
#   * def token = tokenResponse.authToken

Scenario: Article add & delete
    * def timeValidator = read('classpath:helpers/timeValidator.js')
    # Given path 'users/login'
    # And request {"user":{"email":"yamini@test.com","password":"Test@123"}}
    # When method post
    # Then status 200
     # * def token = response.user.token
    # Then match response.user.token != null
    # Then match response.user.bio == "##string"
    # Then match response.user == 
    # """
    # {
    #     "email": "#string",
    #     "username": "#string",
    #     "bio": "##string",
    #     "image": "#string",
    #     "token": "#string"
    #     }
    # """

    Given path 'articles'
    # Given header Authorization = 'Token '+token
    And request 
    """
            {
        "article": {
            "title": "mini",
            "description": "sdfxgh",
            "body": "dgfhgjh",
            "tagList": [
            "bnnb"
            ]
        }
        }
    """
    When method post
    Then status 201
    Then match response.article ==
    """
   {
        "slug": "#string",
        "title": "#string",
        "description": "#string",
        "body": "#string",
        "tagList": "#array",
        "createdAt": "#? timeValidator(_)",
        "updatedAt": "#? timeValidator(_)",
        "favorited": "#boolean",
        "favoritesCount": "#number",
        "author": {
            "username": "#string",
            "bio": "##string",
            "image": "#string",
            "following": "#boolean"
        }
    }
    """

    * def slugid = response.article.slug
    # Given header Authorization = 'Token '+token
    Given path 'articles',slugid
    When method delete
    Then status 204