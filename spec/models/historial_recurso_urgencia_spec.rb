require "rails_helper"

RSpec.describe HistorialRecursoUrgencia, type: :model do
  subject { described_class.new }

  context "Validate model" do
    it { should belongs_to(:institucion) }
    it { should belongs_to(:usuario) }
  end
end