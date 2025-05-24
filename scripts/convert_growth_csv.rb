require 'csv'

input_path  = 'db/csv/original_growth_data.csv'       # 元CSV
output_path = 'db/csv/growth_standards.csv'           # 変換後CSV

# 列名パターン: girl_tall_3, boy_weight_97 など
COLUMN_REGEX = /(?<gender>girl|boy)_(?<type>tall|weight)_(?<percentile>\d+)/

# 変換
CSV.open(output_path, 'w', write_headers: true, headers: ['days_since_birth', 'gender', 'measurement_type', 'percentile', 'value']) do |out_csv|
  CSV.foreach(input_path, headers: true) do |row|
    days = row['days_since_birth'].to_i

    row.headers.each do |header|
      next if header == 'days_since_birth'

      if match = COLUMN_REGEX.match(header)
        gender = match[:gender] == 'girl' ? 'female' : 'male'
        measurement_type = match[:type] == 'tall' ? 'height' : 'weight'
        percentile = match[:percentile].to_i
        value = row[header].to_f

        out_csv << [days, gender, measurement_type, percentile, value]
      end
    end
  end
end

puts "変換完了: #{output_path}"
