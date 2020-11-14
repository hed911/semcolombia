class CreateManyMany < ActiveRecord::Migration[5.0]
  def change
    create_table 'entidad_prestadoras_municipios', :id => false do |t|
      t.column :entidad_prestadora_id, :integer
  		t.column :municipio_id, :integer
  	end
  end
end
#http://railscasts.com/episodes/47-two-many-to-many
