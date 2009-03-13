require 'net/http'
require 'facebooker/parser'

module Facebooker
  module Service
    class Standard
      def initialize(api_base, api_path, api_key)
        @api_base = api_base
        @api_path = api_path
        @api_key = api_key
      end
    
      # TODO: support ssl 
      def post(params)
        attempt = 0
        Parser.parse(params[:method], post_form(url, params))
      rescue Errno::ECONNRESET, EOFError
        if attempt == 0
          attempt += 1
          retry
        end
      end
    
      def post_file(params)
        service_url = url(params.delete(:base))
        result = post_multipart_form(service_url, params)
        Parser.parse(params[:method], result)
      end
    
    private
    
      def post_form(url, params)
        Net::HTTP.post_form(url, params)
      end
    
      def post_multipart_form(url, params)
        Net::HTTP.post_multipart_form(url, params)
      end
    
      def url(base = nil)
        base ||= @api_base
        URI.parse('http://'+ base + @api_path)
      end
    
      # Net::HTTP::MultipartPostFile
      def multipart_post_file?(object)
        object.respond_to?(:content_type) &&
        object.respond_to?(:data) &&
        object.respond_to?(:filename)
      end
    
    end
  end
end