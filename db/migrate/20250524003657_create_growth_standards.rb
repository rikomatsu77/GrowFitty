class CreateGrowthStandards < ActiveRecord::Migration[7.2]
  def change
    create_table :growth_standards do |t|
      t.integer :days_since_birth, null: false
      t.integer :gender, null: false
      t.integer :measurement_type, null: false
      t.integer :percentile, null: false
      t.float :value, null: false

      t.timestamps
    end

    add_index :growth_standards, [:days_since_birth, :gender, :measurement_type, :percentile], unique: true, name: "index_growth_standards_on_all_keys"
  end
end
