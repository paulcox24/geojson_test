#!/bin/bash
# Usage: Fix weird shapes in dissolvedShapes 2011 and 2012 folders
shopt -s nullglob
for f in dissolvedShapes/20**/*Dissolve.geojson
do
  filename="${f%.*}"
  echo "Cleaning up shapes for - $filename"
  ogr2ogr -f GeoJSON -Lco COORDINATE_PRECISION=12 "$filename"simple.geojson "$filename".geojson -dialect sqlite -sql "SELECT PrecinctID, CountyID, ST_SimplifyPreserveTopology(geometry, 0.00001) as geometry FROM OGRGeoJSON"
  ogr2ogr -f GeoJSON -Lco COORDINATE_PRECISION=12 "$filename"clean.geojson "$filename"simple.geojson -dialect sqlite -sql "SELECT PrecinctID, CountyID, ST_MakeValid(geometry) as geometry FROM OGRGeoJSON"
  rm "$filename"simple.geojson
done
mkdir cleaned/2011
mkdir cleaned/2012
mv dissolvedShapes/2011/*clean.geojson cleaned/2011
mv dissolvedShapes/2012/*clean.geojson cleaned/2012
