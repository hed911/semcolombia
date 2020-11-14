require "rails_helper"

RSpec.describe Intension, type: :model do
  subject { described_class.new }

  context "Validate model" do
    it { should belongs_to(:municipio) }
    it { should has_many(:llamadas) }
  end
end