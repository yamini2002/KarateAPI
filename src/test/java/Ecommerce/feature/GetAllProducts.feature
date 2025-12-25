Feature: Products details

Background: preconditions

    * url 'https://rahulshettyacademy.com/api/ecom/'
    * def loginFile = call read("Login.feature")
    * def token = loginFile.token
    * def userId = loginFile.userId

@ignore
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
    * print response.count.length

    And match response.message == "All Products fetched Successfully"

    
    Scenario: Create a new Product
    Given path 'product/add-product'
    Given header Authorization = token
    And multipart field productName = 'Hp Elitebook'
    And multipart field productAddedBy = userId
    And multipart field productCategory = 'Computers and Laptops'
    And multipart field productSubCategory = 'Laptops'
    And multipart field productPrice = "64000"
    And multipart field productDescription = 'Core i7, 16GB RAM, 1TB SSD'
    And multipart field productFor = 'All'

    Given multipart file productImage = {read: "classpath:helpers/laptop.jpg", contentType: 'image/jpeg'}
    When method post
    Then status 201
    Then match response.message == "Product Added Successfully"
    Then match response.productId == "#notnull"
    * def productId = response.productId

    Given path 'product/delete-product/' + productId
    Given header Authorization = token
    When method delete
    Then status 200
    Then match response.message == "Product Deleted Successfully"

    
