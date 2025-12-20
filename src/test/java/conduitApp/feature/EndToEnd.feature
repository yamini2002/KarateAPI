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
    #Get articles of the global feed
    # Given path 'articles'
    # And params {limit: 10 , offset : 0}
    # When method get
    # Then status 200
    # * match response.articles[0].slug == SlugId
    # * match response.articles.createdAt[0] == createdAt
    # * match response.articles.author.username[0] == authorName

    #Get articles using SlugId
    Given path 'articles', SlugId
    Given header Authorization = 'Token ' + token
    When method get
    Then status 200
    * match response.article.slug == SlugId
    * match response.article.createdAt == createdAt
    * match response.article.author.username == authorName

    #Get articles using author
    # Given path 'articles'
    # And param author = response.article.author.username
    # When method get
    # Then status 200
    # * print response.articles
    # * match response.articles[0].slug == SlugId
    # * match response.articles[0].createdAt == createdAt
    # * match response.articles[0].author.username == authorName

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
    
    * def updatedBody = response.article.body
    * match response.article.slug == SlugId
    * def created = new Date(response.article.createdAt).getTime()
    * def updated = new Date(response.article.updatedAt).getTime()
    * assert updated > created

    # Verify Updated Data
    Given path 'articles', SlugId
    Given header Authorization = 'Token ' + token
    When method get
    Then status 200
    * match response.article.body == updatedBody
    * print response.article.body
    * match response.article.description == description

    #Favorite Article
    Given path 'articles',SlugId,'favorite'
    Given header Authorization = 'Token ' + token
    And request {}
    When method post
    Then status 200
    * match response.article.favorited == true
    * match response.article.favoritesCount == 1

    #Again adding it to Favorite Article
    Given path 'articles',SlugId,'favorite'
    Given header Authorization = 'Token ' + token
    And request {}
    When method post
    Then status 200
    * match response.article.favorited == true
    * match response.article.favoritesCount == 1
                
    #Unfavorite the Article
    Given path 'articles',SlugId,'favorite'
    Given header Authorization = 'Token ' + token
    And request {}
    When method delete
    Then status 200
    * match response.article.favorited == false
    * match response.article.favoritesCount == 0

    #Again Unfavorite the Article
    Given path 'articles',SlugId,'favorite'
    Given header Authorization = 'Token ' + token
    And request {}
    When method delete
    Then status 200
    * match response.article.favorited == false
    * match response.article.favoritesCount == 0

    # Add Multiple Comments
    # 1 Comment
    Given path 'articles',SlugId,'comments'
    Given header Authorization = 'Token ' + token
    And request 
    """
    {
        "comment": {
            "body": "hi"
        }
    }
    """ 
    When method POST
    Then status 200
    * def comment1 = response.comment.id

    # 2 Comment
    Given path 'articles',SlugId,'comments'
    Given header Authorization = 'Token ' + token
    And request 
    """
    {
        "comment": {
            "body": "good"
        }
    }
    """ 
    When method POST
    Then status 200
    * def comment2 = response.comment.id

    # 3 Comment
    Given path 'articles',SlugId,'comments'
    Given header Authorization = 'Token ' + token
    And request 
    """
    {
        "comment": {
            "body": "nice"
        }
    }
    """ 
    When method POST
    Then status 200
    * def comment3 = response.comment.id

    # Validate Comment Ordering
    Given path 'articles',SlugId,'comments'
    Given header Authorization = 'Token ' + token
    When method get
    Then status 200
    * print response.comments

    * def totalComments = response.comments.length
    * match totalComments == 3

    # Each comment has id, body, createdAt, author.username
    * match each response.comments ==
    """
        {
            id: "#number",
            createdAt: "#string",
            updatedAt: "#string",
            body: "#string",
            author: {
                username: "#string",
                bio: "##string",
                image: "#string",
                following: "#boolean"
            }
        }
    """
    # Unauthorized Access
    Given path 'articles'
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
    Then status 401


   # Invalid Payload Validation
   #empty title
    Given path 'articles'
    Given header Authorization = 'Token ' + token
    And request 
    """
        {
            "article": {
                "title": "",
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
    Then status 422
    
    # missing body.
    Given path 'articles'
    Given header Authorization = 'Token ' + token
    And request 
    """
        {
            "article": {
                "title": "",
                "description": "Conduit App ",
                "body": "",
                "tagList": [
                    "@smoke",
                    "@regression",
                    "@sanity"
                ]
            }
        }
    """
    When method post
    Then status 422

    #Delete Article
    Given path 'articles',SlugId
    Given header Authorization = 'Token ' + token
    When method delete
    Then status 204

    # Post-Deletion Verification
    # Get article by slug 
    Given path 'articles',SlugId
    Given header Authorization = 'Token ' + token
    When method get
    Then status 404

    # - Get comments 
    Given path 'articles',SlugId,'comments'
    Given header Authorization = 'Token ' + token
    When method get
    Then status 200
    * print response.comments
    * match response == {}

    # - Article not listed
    Given path 'articles'
    Given header Authorization = 'Token ' + token
    When method get
    Then status 200
    * def articleList = get response.articles[*].slug
    * match articleList !contains  SlugId


# 17. Contract / Schema Validation
# Validate schemas for user, article, and comment responses.
