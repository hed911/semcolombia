require "rails_helper"

RSpec.describe CasoDeportivo, type: :model do
  subject { described_class.new }

  context "Validate model" do
    it { should belongs_to(:diagnostico) }
    it { should belongs_to(:entidad_prestadora) }
    it { should belongs_to(:evento_deportivo) }
    it { should belongs_to(:operario) }
  end
end
