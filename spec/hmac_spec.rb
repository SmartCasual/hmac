require "hmac"
require "securerandom"

RSpec.describe HMAC do
  subject(:validation_result) {
    generator = described_class::Generator.new(context:, public:)
    generated_hmac = generator.generate(id:)

    validator = described_class::Validator.new(context:, public:)
    validator.validate(generated_hmac, against_id: id)
  }

  let(:context) { "context" }
  let(:id) { "id" }
  let(:public) { false }

  let(:secret) { "secret" }

  before do
    described_class.configure { |c| c.secret = secret }
  end

  describe "uses the env var HMAC_SECRET as the HMAC key" do
    let(:secret) { SecureRandom.uuid }

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
end
