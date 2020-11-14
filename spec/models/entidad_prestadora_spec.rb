require "rails_helper"

RSpec.describe EntidadPrestadora, type: :model do
  subject { described_class.new }

  context "Validate model" do
    it { should has_many(:usuarios) }
    it { should has_many(:institucions) }
    it { should has_and_belongs_to_many(:municipios) }
  end
end