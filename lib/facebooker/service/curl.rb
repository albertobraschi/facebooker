require 'curb'

module Facebooker
  module Service
    class Curl < Standard
    private
    
      def post_form(url, params, multipart = false)
        response = ::Curl::Easy.http_post(url.to_s, *to_curb_params(params)) do |c|
          c.multipart_form_post = multipart
          c.timeout = Facebooker.timeout 
        end
        response.body_str
      end
    
      def post_multipart_form(url,params)
        post_form(url, params, true)
      end
    
      def to_curb_params(params)
        params.map do |k,v|
          if multipart_post_file?(v)
            # Curl doesn't like blank field names
            field = ::Curl::PostField.file((k.blank? ? 'xxx' : k.to_s), nil, File.basename(v.filename))
            field.content_type = v.content_type
            field.content = v.data
            field
          else
            ::Curl::PostField.content(k.to_s, v.to_s)
          end
        end
      end
    end
  end
end