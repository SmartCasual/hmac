module HMAC
  class << self
    def configure(&block)
      block.call(configuration)
    end

    def configuration
      @configuration ||= HMACConfiguration.new
    end

    def clear_configuration
      @configuration = nil
    end
  end

  HMACConfiguration = Struct.new("HMACConfiguration", :secret)
  class ConfigurationError < StandardError; end
end

require_relative "hmac/generator"
require_relative "hmac/validator"
