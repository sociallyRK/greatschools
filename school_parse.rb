require 'nokogiri'
require 'open-uri'
require 'csv'
require 'json'
require 'awesome_print'
require 'gyoku'

# this method writes the called API data to new lines in the local csv file
class Array
  def to_csv(csv_filename = "hash.csv")
    CSV.open(csv_filename, "a+") do |csv|
      self.each do |hash|
        csv << hash.values
      end
    end
  end
end

# parses CSV file original for city/school names
CSV.foreach('Cities.csv', converters: :numeric) do |row|
  row.inspect
# removes apostrophes, and brackets from arrays for API call in URL
  row = row.to_s.gsub(/[\[\]\"]/, "")
# dynamically adds city names to URL for API
  url = "http://api.greatschools.org/cities/CA/" + "#{row}" + "?key=mzavtrhnujqe75zpmhxllgxx"

# returns hash of city name, and school
  xml = Nokogiri::XML(open(url))
  cities = xml.search('city').map do |city|
    %w[
      name rating
    ].each_with_object({}) do |n, o|
    o[n] = city.at(n).text
    end
  end
# converts hash to format that works with the to_csv method - this
# writes the API data to new lines in the csv file - defined above
# in "def to_csv"
# the name of the csv is up to you and defined here
  cities.to_csv("school_rating.csv")
end