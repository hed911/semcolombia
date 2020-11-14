require "rails_helper"

RSpec.describe Diagnostico, type: :model do
  subject { described_class.new }

  context "Validate model" do
    it { should belongs_to(:super_remision) }
    it { should has_many(:caso_deportivos) }
  end
end