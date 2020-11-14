require "rails_helper"

RSpec.describe Device, type: :model do
  subject { described_class.new }

  context "Validate model" do
    it { should has_many(:ingresos) }
    it { should has_many(:usuarios) }
    it { should has_many(:historial_recursos) }
    it { should has_many(:historial_recurso_urgencias) }
    it { should belongs_to(:municipio) }
    it { should belongs_to(:municipio_alterno) }
    it { should has_many(:camas) }
    it { should belongs_to(:entidad_prestadora) }
    it { should belongs_to(:parent) }
    it { should has_many(:sedes) }
  end
end