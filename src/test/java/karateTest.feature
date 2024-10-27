Feature: plan de pruebas

  Scenario: Validar la obtención de orden
    Given url 'https://petstore.swagger.io/v2/store/order/2'
    When method GET
    Then status 200

  Scenario: Validar que cuando la orden no exista muestre status 404
    Given url 'https://petstore.swagger.io/v2/store/order/23'
    When method GET
    Then status 404

  Scenario Outline: Validar la creación de orden
    Given url 'https://petstore.swagger.io/v2/store/order'
    And request { "id": "<id>", "petId": "<petId>", "quantity": <quantity> }
    When method post
    Then status <status>

    Examples:
      | id   | petId| quantity | status |
      | 3    | 0    | 30       | 200    |
      | 4    | 0    | 25       | 200    |
      | 5    | 0    | 40       | 200    |

  Scenario: Validar que cuando el request es incorrecto muestre el status 500
    Given url 'https://petstore.swagger.io/v2/store/order'
    And request
    """
    {
  "id": 3r,
  "petId": 0,
  "quantity": 0,
  "shipDate": "2024-10-27T06:33:54.461Z",
  "status": "placed",
  "complete": true
    }
    """
    When method post
    Then status 500

  Scenario: Validar eliminación de orden

    Given url 'https://petstore.swagger.io/v2/store/order'
    And request
    """
    {
  "id": 9,
  "petId": 0,
  "quantity": 0,
  "shipDate": "2024-10-28T06:33:54.461Z",
  "status": "placed",
  "complete": true
    }
    """
    When method post
    Then status 200

    Given url 'https://petstore.swagger.io/v2/store/order/9'
    When method delete
    Then status 200
    When method GET
    And match response.message == 'Order not found'
    Then status 404
