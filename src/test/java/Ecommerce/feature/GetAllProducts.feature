Feature: Products details

Background: preconditions

    * url 'https://rahulshettyacademy.com/api/ecom/'
    * def loginFile = call read("Login.feature")
    * def token = loginFile.token
    * def userId = loginFile.userId

Scenario: Get All Products
    Given path 'product/get-all-products'
    Given request {"productName":"","minPrice":null,"maxPrice":null,"productCategory":[],"productSubCategory":[],"productFor":[]}
    Given header Authorization = token 
    When method post
    Then status 200
    And match response.data[0] contains 
    """
    {
      "_id": "#string",
      "productName": "#string",
      "productCategory": "#string",
      "productSubCategory": "#string",
      "productPrice": '#number',
      "productDescription": "#string",
      "productImage": "#string",
      "productRating": "#string",
      "productTotalOrders": "#string",
      "productStatus": '#boolean',
      "productFor": "#string",
      "productAddedBy": "#string",
      "__v": '#number'
    }
    """

    
    