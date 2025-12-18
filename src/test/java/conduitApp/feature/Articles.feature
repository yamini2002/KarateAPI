@smoke
Feature:Articles 

Background: Preconditions
    Given url apiUrl

Scenario: Articles validation

    #Creation of article
    Given path 'articles'
    And request 
    """
    {
        "article": {
            "title": "Dummy Testing",
            "description": "Frameworks",
            "body": "Karate framework",
            "tagList": [
                "@tags"
            ]
        }
    }
    """
    When method post
    Then status 201
    And match response.article.title == "Dummy Testing"
     * def slugId = response.article.slug

    # Modification of an article
    Given path 'articles',slugId
    And request 
    """
       { "article": {
            "title": "Dummy Project"
        }
    }
    """
    When method put
    Then status 200
    And match response.article.title == "Dummy Project"
    * def slugId1 = response.article.slug

    Given path 'articles',slugId1
    When method delete
    Then status 204