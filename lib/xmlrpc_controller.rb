require "xmlrpc_controller/version"
require "nokogiri"
require "httparty"
module XmlrpcController

  # the main method handling the RPC request. It parses the method name, and passes the Nokogiri XML node that represents the params
  # @@xmlrpc_method_name_map contains a map to resolve for non-ruby method names (with a . for example)
  def rpc
    parsed_request = Nokogiri::XML.parse(request.body.read)
    method_name = parsed_request.xpath('methodCall/methodName').text
    method_params = parsed_request.xpath('methodCall/params')
    method_name = @@xmlrpc_method_name_map[method_name] || method_name
    self.send(method_name, method_params)
  end

  # default handling methods for IFTTT to make a simple Webhook bridge
  def ifttt_defaults
    @@xmlrpc_method_name_map ||= {}
    @@xmlrpc_method_name_map.merge!({
      "metaWeblog.getRecentPosts" => :metaWeblog_getRecentPosts,
      "mt.supportedMethods" => :mt_supportedMethods,
      "metaWeblog.newPost" => :metaWeblog_newPost,
      "metaWeblog.getCategories" => :metaWeblog_getCategories,
      "wp.newCategory" => :wp_newCategory
      })
  end

  # actual method doing the webhook request
  def ifttt_new_post(title, body, categories, tags)
    # default protocol to respond to a new post is to POST a request to the url as specified in the tags, body is the payload
    HTTParty.post(tags.first, body: body)
  end

  # convenience method to send back a xmlrpc response
  def rpc_response(value)
    render inline: "xml.instruct! :xml, :version=>'1.0' \n xml.methodResponse { xml.params { xml.param { #{value} }}}", type: :builder, content_type: "text/xml"
  end

  # utility methods to make IFTTT believe we are a wordpress blog
  def mt_supportedMethods(*args)
    rpc_response("xml.value { xml.array {xml.data { xml.value { xml.string 'metaWeblog.getRecentPosts' } \n xml.value { xml.string 'metaWeblog.newPost' } }}} ")
  end

  def metaWeblog_getRecentPosts(*args)
    rpc_response("xml.value { xml.array { xml.data }}")
  end

  def metaWeblog_newPost(args)
    new_post_params = Hash.from_xml(args.children[3].to_s)['param']['value']['struct']['member']
    title = new_post_params[0]['value']['string']
    body = new_post_params[1]['value']['string']
    categories = (new_post_params[2]['value']['array']['data']['value'].class == Array ? new_post_params[2]['value']['array']['data']['value'].map { |e| e['string'] } : [new_post_params[2]['value']['array']['data']['value']['string']] )
    tags = (new_post_params[3]['value']['array']['data']['value'].class == Array ? new_post_params[3]['value']['array']['data']['value'].map { |e| e['string'] } : [new_post_params[3]['value']['array']['data']['value']['string']] )
    ifttt_new_post(title, body, categories, tags)
    rpc_response("xml.value 'nothing'")
  end

  def metaWeblog_getCategories(args)
    rpc_response("xml.value { xml.array { xml.data }}")
  end

  def wp_newCategory(args)
    rpc_response("xml.value { xml.array { xml.data }}")
  end
end
