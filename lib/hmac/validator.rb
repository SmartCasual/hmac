module HMAC
  class Validator
    def initialize(...)
      @generator = HMAC::Generator.new(...)
    end

    def validate(hmac, against_id:)
      present?(hmac) && hmac == @generator.generate(id: against_id)
    end

  private

    def present?(string)
      !string.nil? && !string.empty?
    end
  end
end
