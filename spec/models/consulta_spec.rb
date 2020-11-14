require "rails_helper"

RSpec.describe Consulta, type: :model do
  subject { described_class.new }

  context "Validate model" do
    it { should belongs_to(:caso_salud_publica) }
    it { should belongs_to(:usuario) }
  end
end

