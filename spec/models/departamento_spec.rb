require "rails_helper"

RSpec.describe Departamento, type: :model do
  subject { described_class.new }

  context "Validate model" do
    it { should has_many(:municipios) }
    it { should has_many(:usuarios) }
  end
end