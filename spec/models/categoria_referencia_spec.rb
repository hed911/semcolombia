require "rails_helper"

RSpec.describe CategoriaReferencia, type: :model do
  subject { described_class.new }

  context "Validate model" do
    it { should belongs_to(:municipio) }
  end
end