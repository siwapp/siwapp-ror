#Siwapp API

- [Authentication](#authentication)
- [Invoices](#invoices)
  - [Listing](#listing)
  - [Searching](#searching)
  - [Getting all invoices from a customer](#getting-all-invoices-from-a-customer)
  - [Show](#show)
  - [Create](#create)
  - [Update](#update)
  - [Delete](#delete)
- [Invoice Items](#invoice-items)
  - [Listing](#listing-1)
  - [Show](#show-1)
  - [Create](#create-1)
  - [Update](#update-1)
  - [Delete](#delete-1)
- [Invoice Payments](#invoice-payments)
  - [Listing](#listing-2)
  - [Show](#show-2)
  - [Create](#create-2)
  - [Update](#update-2)
  - [Delete](#delete-2)
- [Taxes](#taxes)
  - [Listing](#listing-3)
  - [Show](#show-3)
  - [Create](#create-3)
  - [Update](#update-3)
  - [Delete](#delete-3)
- [Series](#series)
  - [Listing](#listing-4)
  - [Show](#show-4)
  - [Create](#create-4)
  - [Update](#update-4)
  - [Delete](#delete-4)

## Authentication

  * Generate your security token in you siwapp web application, on the 'My Account/API Token' section.
  * Send that token in every api request as the "Authorization" header:
  `Authorization': 'Token token="abc"'`
  * You can only access the siwapp API through `https` protocol

## Invoices

### Listing

````http
GET https://siwapp-server.com/api/v1/invoices HTTP/1.1
Authorization: Token token="abc"
````

__Response__
````http
HTTP/1.1 200 OK
Content-Type: application/json; charset=UTF-8
X-Pagination: '{"total": "1", "total_pages": 1, "first_page": 1, "last_page": 1, "previous_page": null, "next_page": null, "out_of_bounds": false}'
{   
    "data": [
        {
            "id": 1,
            "type": "invoices",
            "attributes": {
                "name": "Acme",
                "...": "...",
                "series_number": "D-1234-1",
                "status": "paid"
                
            },

            "relationships": {
                "items": {
                    "data": [
                        {
                            "id": 23,
                            "type": "items",
                            "attributes": {
                            "description": "Lorem Ipsum",
                            "unitary_cost": 11.2,
                            "quantity": 23.0,
                            "tax_ids": [2]
                            }
                        }
                    ]
                }
            },

            "links": {
                "download_link": "https://siwapp-server.com/api/v1/templates/1/invoices/1.pdf",
                "customer": "https://siwapp-server.com/api/v1/customers/2",
                "payments": "https://siwapp-server.com/api/v1/invoices/1/payments",
                "items": "https://siwapp-server.com/api/v1/invoices/1/items"
            }
        }

    ]   
}

````

**Pagination Headers**
  * When listing invoices, the results are paginated (20 results per page), you can fetch a specific page using the `page` request parameter.
  * The `X-Pagination` header contains all pagination info.

### Searching.
It's just like listing, but adding the `q` search parameter with any of these keys:
  * `q[with_terms]=acme+inc` invoices with those terms in either name, email or identification
  * `q[customer_id]=3` invoice whose customer has the id=3
  * `q[issue_date_gte]=2012-01-01` invoice whose issue date is greater or equal than `2012-01-01`
  * `q[issue_date_lte]=2012-01-01` invoice whose issue date is less or equal than `2012-01-01`
  * `q[series_id]=3` invoices whose series has the id=3
  * `q[with_status]=paid` invoices whose status is `paid` can also be `draft`, `pending` or `past_due`

If you wanted to search for invoices named 'acme' whose status is 'paid', you would do a GET request to

`https://siwapp-server.com/api/v1/invoices?q[with_status]=paid&q[with_terms]=acme`

### Getting all invoices from a customer

Use a conveniently nested path:

````http
GET https://siwapp-server.com/api/v1/customers/2/invoices HTTP/1.1
Authorization: Token token="abc"
````

### Show

A full representation of the invoice and its items and payments associated.

````http
GET https://siwapp-server.com/api/v1/invoices/1 HTTP/1.1
Authorization: Token token="abc"
````

__Response__
````http
HTTP/1.1 200 OK
Content-Type: application/json; charset=UTF-8
{
    "data": {
        "id": 1,
        "type": "invoices",
        "attributes": {
            "name": "Acme",
            "series_id": "3",
            "draft": "false",
            "sent_by_email": "false",
            "identification": "D-ABC",
            "email": "email@example.com",
            "invoicing_address": "4332 Elm st. ",
            "shipping_address": "",
            "contact_person": "John doe",
            "terms": "...",
            "notes": "...",
            "base_amount":"3554.3",
            "discount_amount": "233",
            "net_amount": "3000",
            "gross_amount": "5422",
            "paid_amount": "234",
            "tax_amount": "88",
            "issue_date": "2015-02-01",
            "due_date": "2016-12-12",
            "days_to_due":"",
            "series_number": "D-1234-1",
            "status": "paid",
            "download_link": "https://siwapp-server.com/api/v1/templates/1/invoices/1.pdf"
        },

        "links": {
            "self": "/api/v1/invoices/1",
            "customer": "/api/v1/customers/2",
            "items": "/api/v1/invoices/1/items",
            "payments": "/api/v1/invoices/1/payments"

        },

        "relationships": {
            "customer": {
                "data": {
                    "id": "2",
                    "attributes": {
                        "identification": "Acme",
                        "url": "https://siwapp-server.com/api/v1/customers/2"
                    }
                } 
            },
            "payments": {
                "data": [{
                    "id": "17",
                    "attributes": {
                        "notes": "first payment ...",
                        "amount": "33.3",
                        "date": "2012-09-09",
                        "url": "https://siwapp-server.com/api/v1/payments/17"
                    } 
                }]    
            },
            "items": {
                "data": [{
                    "id": "33",
                    "attributes": {
                        "description": "CAMEL cigarrettes",
                        "quantity": "2",
                        "unitary_cost": "23.2",
                        "discount": "13",
                        "tax_ids": [2]
                    }
                }]
            }
        }
    }
    
}
````

### Create

````http
POST https://siwapp-server.com/api/v1/invoices HTTP/1.1
Authorization: Token token="abc"
Content-Type: application/json

{
    "invoice": {
        "name": "Acme",
        "issue_date": "2012-12-12",
        "series_id": "3",
        "...": "...",

        "items_attributes": [
            {
                "description": "shoe #1",
                "quantity": 3,
                "discount": 10,
                "tax_ids": [2, 4],
                "unitary_cost": 12.1
            }
        ],
        "payments_attributes": [
            {
                "notes": "payment #1",
                "amount": 32.1,
                "date": "2016-02-02"
            }
        ]
    }
}
````

* The `"invoice"` key must be present.
* You can create invoice with items. Notice the name of the key: `items_attributes`
* You can create invoice with payments. Notice the name of the key: `payments_attributes`

### Update

````http
PUT https://siwapp-server.com/api/v1/invoices/1 HTTP/1.1
Authorization: Token token="abc"
Content-Type: application/json

{
    "invoice": {
        "name": "Acme",
        "series_id": "3",
        "...": "...",

        "items_attributes": [
            {
                "id": "3",
                "description": "shoe MOD #1"
            }
        ],
        "payments_attributes": [
            {
                "id": "33",
                "notes": "MOD Note"
            }
        ]
    }
}
````

* The `"invoice"` key must be present.
* Notice the `_attributes` suffix on the `items` and `payments` keys.
* Items and payments must have id to update them

### Delete

````http
DELETE https://siwapp-server.com/api/v1/invoices/3 HTTP/1.1
Authorization: Token token="abc"
Content-Type: application/json

__Response__

```http
HTTP/1.1 204 NO CONTENT
Content-Type: application/json; charset=utf-8
```

## Invoice Items

### Listing

List all items of invoice with id 1

````http
GET https://siwapp-server.com/api/v1/invoices/1/items HTTP/1.1
Authorization: Token token="abc"
````

__Response__
````http
HTTP/1.1 200 OK
Content-Type: application/json; charset=UTF-8

[
    {
        "id": "123",
        "description": "shoe",
        "unitary_cost": "33.2",
        "...": "...",
        "url": "https://siwapp-server.com/api/v1/items/123",
        "taxes": "https://siwapp-server.com/api/v1/items/123/taxes"
    }
]
````

### Show

A full representation of the item, its taxes and a reference to the invoice it belongs to.

````http
GET https://siwapp-server.com/api/v1/items/123 HTTP/1.1
Authorization: Token token="abc"
````

__Response__
````http
HTTP/1.1 200 OK
Content-Type: application/json; charset=UTF-8
{
    "id": 123,
    "name": "shoe",
    "...": "...",
    "url": "https://siwapp-server.com/api/v1/items/123",
    "invoice": {
        "id": "1",
        "series_number":"D-1234-1",
        "url": "https://siwapp-server.com/api/v1/invoices/1"
    },
    "taxes": [
        {
            "id": "2",
            "name": "VAT 21%"
            "url": "https://siwapp-server.com/api/v1/taxes/2"
        }
    ]
}
````

### Create

Create an item for the invoice with id=1

````http
POST https://siwapp-server.com/api/v1/invoices/1/items HTTP/1.1
Authorization: Token token="abc"
Content-Type: application/json

{
    "item": {
        "description": "another shoe",
        "unitary_cost": 33.2,
        "discount": 12,
        "...": "...",
        "taxes": ["VAT 21%", "RETENTION"],
        "tax_ids": [3]
    }
}
````

* The `"item"` key must be present.
* You can add taxes either by name, through the `"taxes"` key, or by id, through the `"tax_ids"` key.

### Update

````http
PUT https://siwapp-server.com/api/v1/items/12 HTTP/1.1
Authorization: Token token="abc"
Content-Type: application/json

{
    "item": {
        "name": "modified shoe",
        "quantity": "2"
    }
}
````

* The `"item"` key must be present.
* Only the attributes present in the json sent are updated. The rest remain the same

### Delete

````http
DELETE https://siwapp-server.com/api/v1/items/12 HTTP/1.1
Authorization: Token token="abc"
Content-Type: application/json
````

__Response__

```http
HTTP/1.1 204 NO CONTENT
Content-Type: application/json; charset=utf-8
```

## Invoice Payments

### Listing

List all payments of invoice with id 1

````http
GET https://siwapp-server.com/api/v1/invoices/1/payments HTTP/1.1
Authorization: Token token="abc"
````

__Response__
````http
HTTP/1.1 200 OK
Content-Type: application/json; charset=UTF-8

[
    {
        "id": "333",
        "notes": "first payment",
        "amount": "33.2",
        "...": "...",
        "url": "https://siwapp-server.com/api/v1/payments/333"
    }
]
````

### Show

A full representation of the payment and a reference to the invoice it belongs to.

````http
GET https://siwapp-server.com/api/v1/payments/333 HTTP/1.1
Authorization: Token token="abc"
````

__Response__
````http
HTTP/1.1 200 OK
Content-Type: application/json; charset=UTF-8
{
    "id": "333",
    "name": "first payment",
    "...": "...",
    "url": "https://siwapp-server.com/api/v1/items/333",
    "invoice": {
        "id": "1",
        "series_number":"D-1234-1",
        "url": "https://siwapp-server.com/api/v1/invoices/1"
    }
}
````

### Create

Create a payment for the invoice with id=1

````http
POST https://siwapp-server.com/api/v1/invoices/1/payments HTTP/1.1
Authorization: Token token="abc"
Content-Type: application/json

{
    "payment": {
        "notes": "second payment",
        "amount": 33.2,
        "...": "..."
    }
}
````

* The `"payment"` key must be present.

### Update

````http
PUT https://siwapp-server.com/api/v1/payments/12 HTTP/1.1
Authorization: Token token="abc"
Content-Type: application/json

{
    "payment": {
        "notes": "modified second payment"
    }
}
````

* The `"payment"` key must be present.
* Only the attributes present in the json sent are updated. The rest remain the same

### Delete

````http
DELETE https://siwapp-server.com/api/v1/payments/12 HTTP/1.1
Authorization: Token token="abc"
Content-Type: application/json
````

__Response__

```http
HTTP/1.1 204 NO CONTENT
Content-Type: application/json; charset=utf-8
```

## Taxes

### Listing

List all taxes

````http
GET https://siwapp-server.com/api/v1/taxes HTTP/1.1
Authorization: Token token="abc"
````

__Response__
````http
HTTP/1.1 200 OK
Content-Type: application/json; charset=UTF-8

[
    {
        "id": "2",
        "name": "VAT 21%",
        "value": "21",
        "default": "true",
        "active": "true",
        "url": "https://siwapp-server.com/api/v1/taxes/2"
    }
]
````

### Show

A full representation of the tax.

````http
GET https://siwapp-server.com/api/v1/taxes/2 HTTP/1.1
Authorization: Token token="abc"
````

__Response__
````http
HTTP/1.1 200 OK
Content-Type: application/json; charset=UTF-8
{
    "id": "2",
    "name": "name 21%",
    "value": "21",
    "active": "true",
    "default": "false",
    "url": "https://siwapp-server.com/api/v1/taxes/2"
}
````

### Create

Create a tax

````http
POST https://siwapp-server.com/api/v1/taxes HTTP/1.1
Authorization: Token token="abc"
Content-Type: application/json

{
    "tax": {
        "name": "VAT 9%",
        "value": 9,
        "active": true,
        "default": false
    }
}
````

* The `"tax"` key must be present.

### Update

````http
PUT https://siwapp-server.com/api/v1/taxes/5 HTTP/1.1
Authorization: Token token="abc"
Content-Type: application/json

{
    "tax": {
        "name": "modified VAT"
    }
}
````

* The `"tax"` key must be present.
* Only the attributes present in the json sent are updated. The rest remain the same

### Delete

````http
DELETE https://siwapp-server.com/api/v1/taxes/12 HTTP/1.1
Authorization: Token token="abc"
Content-Type: application/json
````

__Response__

```http
HTTP/1.1 204 NO CONTENT
Content-Type: application/json; charset=utf-8
```

## Series

### Listing

List all series

````http
GET https://siwapp-server.com/api/v1/series HTTP/1.1
Authorization: Token token="abc"
````

__Response__
````http
HTTP/1.1 200 OK
Content-Type: application/json; charset=UTF-8

[
    {
        "id": "2",
        "name": "Sample Series A",
        "value": "SSA-",
        "enabled": true,
        "default": null,
        "url": "https://siwapp-server.com/api/v1/taxes/2"
    }
]
````

### Show

A full representation of the Series

````http
GET https://siwapp-server.com/api/v1/series/2 HTTP/1.1
Authorization: Token token="abc"
````

__Response__
````http
HTTP/1.1 200 OK
Content-Type: application/json; charset=UTF-8
{
    "name": "Sample Series A",
    "value": "SSA-",
    "enabled": true,
    "default": null,
    "first_number": 1000,
    "url": "https://siwapp-server.com/api/v1/taxes/2"
}
````

### Create

Create a series

````http
POST https://siwapp-server.com/api/v1/series HTTP/1.1
Authorization: Token token="abc"
Content-Type: application/json

{
    "series": {
        "name": "IT services",
        "value": "ITS-",
        "enabled": true,
        "default": null
    }
}
````

* The `"series"` key must be present.

### Update

````http
PUT https://siwapp-server.com/api/v1/taxes/5 HTTP/1.1
Authorization: Token token="abc"
Content-Type: application/json

{
    "series": {
        "name": "IT services mod"
    }
}
````

* The `"series"` key must be present.
* Only the attributes present in the json sent are updated. The rest remain the same

### Delete

````http
DELETE https://siwapp-server.com/api/v1/series/12 HTTP/1.1
Authorization: Token token="abc"
Content-Type: application/json
````

__Response__

```http
HTTP/1.1 204 NO CONTENT
Content-Type: application/json; charset=utf-8
```
