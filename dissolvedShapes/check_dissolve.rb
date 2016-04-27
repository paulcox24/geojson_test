require 'json'
require 'pry'
all_files = Dir.glob("20**/*Dissolve.geojson")
dup_precincts = []
no_county = []
multi_poly = {}

all_files.each do |file|
  begin
    filename = File.basename(file)
    json = JSON.parse(File.read(file))['features']
    precincts = json.map{|f| f['properties']['PrecinctID']}
    county = json.map{|f| f['properties']['CountyID']}.compact.uniq
    multi = json.count{|f| f['geometry']['type'] == 'MultiPolygon'}
    dup_precincts << filename if precincts.count > precincts.uniq.count
    no_county << filename if county.count != 1
    multi_poly[filename] = multi if multi > 0
  rescue
    binding.pry
  end
end

puts "Duplicate Precincts: " + dup_precincts.inspect
puts "County Missing: " + no_county.inspect
puts "MultiPolygons: " + multi_poly.inspect