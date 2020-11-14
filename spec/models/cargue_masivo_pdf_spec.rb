require "rails_helper"

RSpec.describe CargueMasivoPdf, type: :model do
  subject { described_class.new }

  context "Validate model" do
    it { should belongs_to(:municipio) }
    it { should belongs_to(:usuario) }
    it { should belongs_to(:laboratorio) }
  end
end
