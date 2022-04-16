module HMAC
  class Generator
    def initialize(context:, public: false, secret: nil)
      @context = context
      @public = public
      @digest = OpenSSL::Digest.new("SHA256")
      @hmac_key = secret || HMAC.configuration.secret

      raise ConfigurationError, "HMAC secret is not configured" if @hmac_key.nil?
    end

    def generate(id:, extra_fields: {})
      OpenSSL::HMAC.new(hmac_key, digest).tap do |hmac|
        hmac.update(id.to_s)
        hmac.update(context.to_s)
        hmac.update("public") if public?
        extra_fields.sort.each do |_, value|
          hmac.update(value.to_s)
        end
      end.hexdigest
    end

  private

    attr_reader(
      *%I[
        context
        digest
        hmac_key
      ],
    )

    def public?
      !!@public
    end
  end
end
