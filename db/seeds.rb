require 'csv'

csv_path = Rails.root.join('db/csv/growth_standards.csv')

puts "Importing growth standards..."

CSV.foreach(csv_path, headers: true) do |row|
  GrowthStandard.create!(
    days_since_birth: row['days_since_birth'].to_i,
    gender: row['gender'],
    measurement_type: row['measurement_type'],
    percentile: row['percentile'].to_i,
    value: row['value'].to_f
  )
end

puts "Import complete!"
