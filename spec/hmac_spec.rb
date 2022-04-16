require "hmac"
require "securerandom"

RSpec.describe HMAC do
  subject(:validation_result) {
    generator = described_class::Generator.new(context:, public:, secret: secret_override)
    generated_hmac = generator.generate(id:, extra_fields:)

    validator = described_class::Validator.new(context:, public:, secret: secret_override)
    validator.validate(generated_hmac, against_id: id, extra_fields:)
  }

  let(:context) { "context" }
  let(:id) { "id" }
  let(:public) { false }
  let(:extra_fields) { {} }

  let(:secret) { "secret" }
  let(:secret_override) { nil }

  before do
    described_class.configure { |c| c.secret = secret }
  end

  describe "if no secret is provided" do
    let(:secret) { nil }
    let(:secret_override) { nil }

    it "raises an error" do
      expect { validation_result }.to raise_error(described_class::ConfigurationError)
    end
  end

  describe "uses the configured secret as the HMAC key" do
    let(:secret) { SecureRandom.uuid }

    it { is_expected.to be_truthy }
  end

  describe "uses the passed in secret in preference to the configured secret" do
    let(:secret) { nil }
    let(:secret_override) { SecureRandom.uuid }

    it { is_expected.to be_truthy }
  end

  describe "includes the context in the HMAC" do
    let(:context) { SecureRandom.uuid }

    it { is_expected.to be_truthy }
  end

  describe "includes the public flag in the HMAC" do
    context "when public is true" do
      let(:public) { true }

      it { is_expected.to be_truthy }
    end

    context "when public is false" do
      let(:public) { false }

      it { is_expected.to be_truthy }
    end
  end

  describe "generates a HMAC for a given ID" do
    let(:id) { SecureRandom.uuid }

    it { is_expected.to be_truthy }
  end

  describe "generates a HMAC for a given ID and extra fields" do
    let(:id) { SecureRandom.uuid }
    let(:extra_fields) { { "extra_field" => SecureRandom.uuid } }

    it { is_expected.to be_truthy }
  end
end
