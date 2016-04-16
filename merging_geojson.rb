def merge_polygons(file)
  require 'json'
  json = JSON.parse(File.read(file))["features"]
  precinct_groups = json.group_by{|g| g["properties"]["PrecinctID"]}
  merged_precincts = []
  precinct_groups.each do |precinct, data|
    properties = data.first['properties']
    properties['SubPrecinc'] = ""
    properties['SHAPE_Leng'] = ""
    properties['SHAPE_Area'] = ""

    coordinates = []
    data.each do |geo|
      geo = geo['geometry']
      if geo['type'] == 'Polygon'
        coordinates << geo['coordinates']
      elsif geo['type'] == 'MultiPolygon'
        coordinates += geo['coordinates']
      end
    end

    new_geometry = {
      'type'=>'MultiPolygon',
      'coordinates'=> coordinates
    }

    template = {
      "type"=>"Feature",
      "properties" => properties,
      "geometry" => new_geometry
    }
    merged_precincts << template
  end
  merged_precincts
end

def merged_county_files(file)
  to_write = {"type"=>"FeatureCollection",
    "crs"=>{"type"=>"name", "properties"=>{"name"=>"urn:ogc:def:crs:OGC:1.3:CRS84"}},
    "features"=> merge_polygons(file)}
    filename = File.basename(file, ".geojson")
  File.open("#{filename}Merged.geojson", "w") do |f|
    f.write(to_write.to_json)   
  end
end

def merge_folder
  files = Dir["*.geojson"]
  year = File.basename(Dir.getwd).to_i
  files.each do |file|
    merged_county_files file
  end
end

