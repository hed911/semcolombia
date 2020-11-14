require "rails_helper"

RSpec.describe CasoSaludPublica, type: :model do
  subject { described_class.new }

  context "Validate model" do
    it { should belongs_to(:usuario) }
    it { should belongs_to(:laboratorio) }
    it { should belongs_to(:institucion) }
    it { should belongs_to(:entidad_prestadora) }
    it { should belongs_to(:aseguradora) }
    it { should belongs_to(:country) }
    it { should belongs_to(:departamento) }
    it { should belongs_to(:municipio) }
    it { should belongs_to(:cargue_masivo) }
    it { should belongs_to(:municipio_origen) }
    it { should belongs_to(:departamento_origen) }
    it { should belongs_to(:barrio) }
    it { should belongs_to(:diagnostico_principal) }
    it { should belongs_to(:municipio_contacto_uno) }
    it { should belongs_to(:departamento_contacto_uno) }
    it { should belongs_to(:country_contacto_uno) }
    it { should belongs_to(:country_uno) }
    it { should belongs_to(:country_dos) }
    it { should belongs_to(:usuario_seguimiento) }
    it { should belongs_to(:usuario_cierre) }
    it { should belongs_to(:touched_by) }
    it { should belongs_to(:responsable_investigacion) }
  end
end