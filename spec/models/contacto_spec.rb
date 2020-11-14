require "rails_helper"

RSpec.describe Contacto, type: :model do
  subject { described_class.new }

  context "Validate model" do
    it { should belongs_to(:parent) }
    it { should belongs_to(:son) }
  end
end