require_relative "generator"

module HMAC
  class Validator
    def initialize(...)
      @generator = Generator.new(...)
    end

    def validate(hmac, against_id:, extra_fields: {}) # rubocop:disable Naming/PredicateMethod
      present?(hmac) && hmac == @generator.generate(id: against_id, extra_fields:)
    end

  private

    def present?(string)
      !string.nil? && !string.empty?
    end
  end
end
