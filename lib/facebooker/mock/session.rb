require 'facebooker/session'

module Facebooker
  class MockSession < Session
    def secured?
      true
    end

    def secure!
      @uid = 1
      true
    end
 
    def service
      @service ||= Service::Mock.new
    end
  end
end