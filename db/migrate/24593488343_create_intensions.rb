class CreateIntensions < ActiveRecord::Migration[5.0]
  def change
    create_table :intensions do |t|
      t.string                   :nombre
      t.timestamps
    end
  end
end
