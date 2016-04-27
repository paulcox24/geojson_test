#!/bin/bash
# Usage: Dissolve subPrecincts into Precincts in 2011 and 2012 folders
shopt -s nullglob
for f in 20**/*.geojson
do
  filename="${f%.*}"
  echo "Dissolving shapes for - $filename"
  ogr2ogr -f GeoJSON "$filename"Dissolve.geojson "$filename".geojson -dialect sqlite -sql "SELECT PrecinctID as PrecinctID, ST_Union(geometry) as geometry, CountyID as CountyID FROM OGRGeoJSON GROUP BY PrecinctID"
done