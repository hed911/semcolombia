require "rails_helper"

RSpec.describe HistorialUrgencia, type: :model do
  subject { described_class.new }

  context "Validate model" do
    it { should belongs_to(:institucion) }
    it { should belongs_to(:usuario) }
    it { should belongs_to(:hospital_user) }
  end
end
