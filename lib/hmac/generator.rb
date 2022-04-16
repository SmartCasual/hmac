module HMAC
  class Generator
    def initialize(context:, public: false, secret: nil)
      @context = context
      @public = public
      @digest = OpenSSL::Digest.new("SHA256")
      @hmac_key = secret || HMAC.configuration.secret

      raise ConfigurationError, "HMAC secret is not configured" if @hmac_key.nil?
    end

    def generate(id:)
      OpenSSL::HMAC
        .new(hmac_key, digest)
        .update(id.to_s)
        .update(context)
        .tap { |hmac| hmac.update("public") if public? }
        .hexdigest
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
