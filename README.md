genesis.js
==========

node.js client library for Genesis Payment Gateway

Overview
--------

Client Library for processing payments through Genesis Payment Processing Gateway. Its highly recommended to checkout "Genesis Payment Gateway API Documentation" first, in order to get an overview of Genesis's Payment Gateway API and functionality.

Requirements
------------

* node.js v0.10.0 or newer
* npm


Installation
------------

```sh
npm install genesis.js
```

Getting Started
---------------

In order to process transactions via Genesis, you'll have to acquire the necessary credentials in order to connect to the Gateway.

Configuration
-------------

You can override the path to the directory holding your configuration files (by default its ```config``` in the root directory of the module) via environmental variable ```NODE_CONFIG_DIR```. The first file to parse configuration from, is ```<your-config-dir>/default.json``` and based on the environment variable (```NODE_ENV```), you can specify your custom file; for example ```<your-config-dir>/<NODE_ENV_NAME>.json```.

Note: Its good practice to prevent web/direct access to your config directory and protect the files inside

Sale Transaction
----------------

- JavaScript

```js
var crypto, failure, genesis, success, transaction;

genesis = require('lib/genesis.js');

crypto = require('crypto');

transaction = new genesis.transaction();

failure = function(error, body) {
  return console.log(error, body);
};

success = function(response, body) {
  return console.log(body);
};

transaction.sale({
  transaction_id: crypto.randomBytes(16).toString('hex'),
  usage: 'Demo Payment Transaction',
  description: 'This is my first payment',
  remote_ip: '127.0.0.1',
  amount: '100',
  currency: 'USD',
  card_holder: 'John Doe',
  card_number: '4200000000000000',
  cvv: '000',
  expiration_month: 12,
  expiration_year: 2020,
  customer_email: 'email@example.com',
  customer_phone: '0123456789',
  billing_address: {
    first_name: 'John',
    last_name: 'Doe',
    address1: '123 Str.',
    zip_code: '10000',
    city: 'New York',
    country: 'US'
  }
}, success, failure);
```

- CoffeeScript

```coffee
genesis = require 'lib/genesis.js'
crypto  = require 'crypto'

transaction = new genesis.transaction();

failure = (error, body) ->
    console.log error, body

success = (response, body) ->
   console.log body

transaction.sale {
    transaction_id    : crypto.randomBytes(16).toString('hex')
    usage             : 'Demo Payment Transaction'
    description       : 'This is my first payment'
    remote_ip         : '127.0.0.1'
    amount            : '100'
    currency          : 'USD'
    card_holder       : 'John Doe'
    card_number       : '4200000000000000'
    cvv               : '000'
    expiration_month  : 12
    expiration_year   : 2020
    customer_email    : 'email@example.com'
    customer_phone    : '0123456789'
    billing_address   :
        first_name: 'John'
        last_name : 'Doe'
        address1  : '123 Str.'
        zip_code  : '10000'
        city      : 'New York'
        country   : 'US'
    }
    , success
    , failure
```

The example above is going to create a Sale (Authorize w/ immediate Capture) transaction for the amount of $100.

Web Payment Form Transaction
----------------------------

- JavaScript

```js
var crypto, failure, genesis, success, transaction;

genesis = require('lib/genesis.js');

crypto = require('crypto');

transaction = new genesis.transaction();

failure = function(error, body) {
  return console.log(error, body);
};

success = function(response, body) {
  return console.log(body);
};

transaction.wpf_create({
  locale: 'de',
  transaction_id: crypto.randomBytes(16).toString('hex'),
  usage: 'Demo WPF Transaction',
  description: 'This is my first WPF transaction',
  remote_ip: '127.0.0.1',
  amount: '100',
  currency: 'USD',
  customer_email: 'email@example.com',
  customer_phone: '0123456789',
  notification_url: 'http://my.host.name.tld:1234/notifier',
  return_success_url: 'http://my.host.name.tld/success',
  return_failure_url: 'http://my.host.name.tld/failure',
  return_cancel_url: 'http://my.host.name.tld/cancel',
  billing_address: {
    first_name: 'John',
    last_name: 'Doe',
    address1: '123 Str.',
    zip_code: '10000',
    city: 'New York',
    country: 'US'
  },
  transaction_types: ['authorize3d', 'sale']
});
```

- CoffeeScript

```coffee
genesis = require 'lib/genesis.js'
crypto  = require 'crypto'

transaction = new genesis.transaction();

failure = (error, body) ->
    console.log error, body

success = (response, body) ->
   console.log body
   
transaction.wpf_create {
    locale            : 'de'
    transaction_id    : crypto.randomBytes(16).toString('hex')
    usage             : 'Demo WPF Transaction'
    description       : 'This is my first WPF transaction'
    remote_ip         : '127.0.0.1'
    amount            : '100'
    currency          : 'USD'
    customer_email    : 'email@example.com'
    customer_phone    : '0123456789'
    notification_url  : 'http://my.host.name.tld:1234/notifier'
    return_success_url: 'http://my.host.name.tld/success'
    return_failure_url: 'http://my.host.name.tld/failure'
    return_cancel_url : 'http://my.host.name.tld/cancel'
    billing_address   :
        first_name: 'John'
        last_name : 'Doe'
        address1  : '123 Str.'
        zip_code  : '10000'
        city      : 'New York'
        country   : 'US'
    transaction_types: [
        'authorize3d'
        'sale'
    ]
}
```

The example above is going to create a new ```WPF``` instance with German (```de```) locale and allowed transaction types - ```authorize3d``` (Authorize w/ 3D-Secure asynchronously) and ```sale``` for the amount of $100.


Notification Listener
---------------------

- JavaScript

```js
var args, cb, genesis, notification, notification_url;

genesis = require('lib/genesis.js');

notification = new genesis.notification();

args = {
  host: 'my.host.name.tld',
  port: 1234,
  path: '/listen'
};

cb = function(error, result) {
    if (!error) {
      return console.log(result);
    } else {
      return console.log(error);
    }
};

notification.listen(args, cb);

notification_url = notification.getUrl();
```

- CoffeeScript

```coffee
genesis = require 'lib/genesis.js'

notification = new genesis.notification()

args = {
  host: 'my.host.name.tld'
  port: 1234
  path: '/listen'
}

cb = (error, result) =>
  if not error
    console.log result
  else
    console.log error

notification.listen args, cb

notification_url = notification.getUrl()
```

The example above would create a notification listener on ```my.host.name.tld:1234/notifier``` which you can use as notification handler for async transactions. If a notification is received and its successfully verified against our backend, the callback will be called with details of the transaction you're being notified for.

Transaction Types
-----------------

```text
account_verification
avs
authorize
authorize3d
blacklist
capture
chargeback
chargeback_by_date
credit
fraud_report
fraud_report_by_date
init_recurring
init_recurring_sale3d
reconcile
reconcile_by_date
recurring_sale
refund
retrieval
retrieval_by_date
payout
sale
sale3d
void
wpf_create
wpf_reconcile
```

Transaction Parameters
----------------------

In order to get a full list of required and optional parameters, please consult our API Documentation.