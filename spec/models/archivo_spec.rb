require "rails_helper"

RSpec.describe Archivo, type: :model do
  subject { described_class.new }

  context "Validate model" do
    it { should belongs_to(:muestra) }
    it { should belongs_to(:cargue_masivo_pdf) }
  end
end
