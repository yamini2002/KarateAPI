@home
Feature: Feed Articles

Background: Preconditions
    Given url apiUrl

Scenario: Favorite article
    # Step 1: Get articles of the global feed
    Given path 'articles'
    And params {limit: 10 , offset : 0}
    When method get
    Then status 200

    # Step 2: Get the favorites count and slug ID for the first article
    * def firstArticle = response.articles[0]
    * def slugId = firstArticle.slug
    * def initialFavoritesCount = firstArticle.favoritesCount

    # Step 3: Make POST request to increase favorites count for the first article
    Given path 'articles', slugId, 'favorite'
    And request {}
    When method post
    Then status 200

    # Step 4: Verify response schema for single article
    * match response.article ==
    """
    {
      id: "#number",
      slug: "#string",
      title: "#string",
      description: "##string",
      body: "#string",
      createdAt: "#string",
      updatedAt: "#string",
      authorId: "#number",
      tagList: "#[]",
      author: { 
        username: "#string", 
        bio: "##string", 
        image: "#string", 
        following: "#boolean" 
      },
      favoritedBy: "#[]",
      favorited: true,
      favoritesCount: "#number"
    }
    """

    # # # Step 5: Verify favorites count increment
    * match response.article.favoritesCount == initialFavoritesCount + 1

    Given path 'articles', slugId, 'favorite'
    And request {}
    When method delete
    Then status 200

    * match response.article.favoritesCount == initialFavoritesCount


    # Step 6: Get all favorite articles for the author
    Given path 'articles'
    # And param favorited = response.article.author.username
    When method get
    Then status 200
    * print response.articles[0]

    # # Step 7: Verify response schema for array of favorite articles
   And match each response.articles ==
"""
    {
      slug: "#string",
      title: "#string",
      description: "##string",
      body: "#string",
      tagList: "#[]",
      createdAt: "#string",
      updatedAt: "#string",
      favorited: "#boolean",
      favoritesCount: "#number",
      author: {
        username: "#string",
        bio: "##string",
        image: "#string",
        following: "#boolean"
      }
    }
    """


    # # Step 8: Verify that slug ID from Step 2 exists in favorite articles
    # * def slugs = response.articles[*].slug
    # And match slugs contains slugId
