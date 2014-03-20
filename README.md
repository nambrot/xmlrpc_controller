# XmlrpcController

Small gem to accept XMLRPC calls in your controller, written for providing Webhooks as a IFTTT trigger by pretending to be a Wordpress blog. Entirely inspired from [femto113/node-ifttt-webhook](https://github.com/femto113/node-ifttt-webhook) which is entirely inspired from [captn3m0/ifttt-webhook](https://github.com/captn3m0/ifttt-webhook)

## How to use

### For ITTT

````
class RpcController < ApplicationController
  include XmlrpcController
  # you want to be selective with this
  skip_before_filter :verify_authenticity_token
  
  before_filter :ifttt_webhook_defaults

  # override when needed, by default it will POST a request to the url as specified in the tags, body is the payload
  def ifttt_new_post(title, body, categories, tags)
  end
  
end

````

### Other Uses

The module will call try to call the method defined on the controller as specified in the RPC call with a Nokogiri Object as the argument.