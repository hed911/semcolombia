require "rails_helper"

RSpec.describe Device, type: :model do
  subject { described_class.new }

  context "Validate model" do
    it { should belongs_to(:ambulancia) }
    it { should belongs_to(:tripulante) }
    it { should belongs_to(:primer_respondiente) }
  end
end