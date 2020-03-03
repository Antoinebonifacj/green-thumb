# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'csv'

def generate_model_from_csv(model_class, csv_file)
  csv_options = { col_sep: ',',
                  quote_char: '"',
                  headers: :first_row,
                  converters: :numeric,
                  header_converters: :symbol }
  CSV.read("db/#{csv_file}", csv_options).each_with_index do |row, i|
    # grab all columns and generate instance of the model
    args = row.to_h
    model = model_class.new(args)
    begin
      valid = model.save
    rescue ActiveRecord::RecordNotUnique
      puts "Couldn't create row #{i} from #{csv_file}. Already in DB!"
    else
      unless valid
        puts "Couldn't create row #{i} from #{csv_file}. Validation error?"
        model.errors.messages.each { |k, v| puts "\t#{k}: #{v}"}
      else
        puts "Made model for row #{i} from #{csv_file}."
      end
    end
  end
end

# generate weather stations
generate_model_from_csv(WeatherStation, 'weather_stations.csv')

# generate users
generate_model_from_csv(WeatherStation, 'users.csv')
