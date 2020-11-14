require "rails_helper"

RSpec.describe CargueMasivo, type: :model do
  subject { described_class.new }

  context "Validate model" do
    it { should belongs_to(:municipio) }
    it { should belongs_to(:usuario) }
  end
end