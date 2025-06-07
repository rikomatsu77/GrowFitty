class CreateMeasurements < ActiveRecord::Migration[7.2]
  def change
    create_table :measurements do |t|
      t.references :child, null: false, foreign_key: true
      t.datetime :measured_on, null: false
      t.string :measurement_type, null: false
      t.float :value, null: false
      t.float :percentile

      t.timestamps
    end
  end
end
