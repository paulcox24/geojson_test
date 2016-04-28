require 'json'
require 'pry'

def problem_files
  no_good = []
  files = Dir.glob("**/*.geojson")

  files.each do |f|
    shapes = JSON.parse(File.read(f))['features']
    shapes.each do |shape|
      coords = shape['geometry']['coordinates']
      coords.each do |coord|
        if shape['geometry']['type'] == 'MultiPolygon'
          coord.each do |c|
            if !closed? c
              no_good << f 
            end
          end
        else
          if !closed? coord
            no_good << f
          end 
        end
      end
    end
  end

  p no_good.uniq
end

def closed?(coord)
  coord.first == coord.last
end

def close(coords)
  coords.map do |coord|
    coord[-1] = coord.first
    coord
  end
end

problem_files