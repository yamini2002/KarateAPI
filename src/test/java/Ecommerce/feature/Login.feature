@test
Feature: Login functionality

Background: Preconditions
    * url 'https://rahulshettyacademy.com/api/ecom'

Scenario: To check Login
    Given path 'auth/login'
    Then request {"userEmail":"sandy03@gmail.com","userPassword":"Test@123"}
    When method post
    Then status 200

    * def token = response.token
    * def userId = response.userId
    * match response.message == "Login Successfully"