class ChangeMeasurementsColumnsNullable < ActiveRecord::Migration[7.2]
  def change
    change_column_null :measurements, :measured_on, true
    change_column_null :measurements, :value, true
  end
end
