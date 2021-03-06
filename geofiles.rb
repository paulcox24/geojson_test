@county_code = {
  1 => "Beaver",
  2 => "BoxElder",
  3 => "Cache",
  4 => "Carbon",
  5 => "Daggett",
  6 => "Davis",
  7 => "Duchesne",
  8 => "Emery",
  9 => "Garfield",
  10 => "Grand",
  11 => "Iron",
  12 => "Juab",
  13 => "Kane",
  14 => "Millard",
  15 => "Morgan",
  16 => "Piute",
  17 => "Rich",
  18 => "SaltLake",
  19 => "SanJuan",
  20 => "Sanpete",
  21 => "Sevier",
  22 => "Summit",
  23 => "Tooele",
  24 => "Uintah",
  25 => "Utah",
  26 => "Wasatch",
  27 => "Washington",
  28 => "Wayne",
  29 => "Weber"
}

def county_files(file, year)
  json = JSON.parse(File.read(file))
  groups = json.group_by{ |c| c['properties']['CountyID'] }
  groups.each do |county, features|
    to_write = {"type"=>"FeatureCollection",
      "crs"=>{"type"=>"name", "properties"=>{"name"=>"urn:ogc:def:crs:OGC:1.3:CRS84"}},
      "features"=> features}
    county = @county_code[county]
    File.open("#{county + year.to_s}.geojson", "w") do |f|
      f.write(to_write.to_json)   
    end
  end
end

def get_geo_ids
  @all_ids = Hash.new([])
  files = Dir.glob("cleaned/**/*clean.geojson")
  files.each do |file|
    json = JSON.parse(File.read(file))['features']
    county_id = json.first['properties']['CountyID']
    county = @county_code[county_id].upcase
    @all_ids[county] |= json.map{|f| f['properties']['PrecinctID']}
  end
  @all_ids.each{|k,v| v.sort!}
  File.open("geo_ids.json", "w") do |f|
      f.write(@all_ids.to_json)
  end
end

def ids_from_mapping
  @all_ids = Hash.new([])
  files = Dir.glob("mapping/*Mapping.json")
  files.each do |file|
    county = File.basename(file, ".json").gsub("Mapping","")
    @all_ids[county] = JSON.parse(File.read(file))['MAPPING'].values.uniq
  end
  File.open("mapping_ids.json", "w") do |f|
      f.write(@all_ids.to_json)
  end
end

def geo_diff_mapping(geo,mapp)
  bad = Hash.new([])
  geo.each{|g,v| bad ||= (v - mapp[g]) }
  mapp.each{|m,v| bad ||= (m - geo[m]) }
  bad
end