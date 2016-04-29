#!/bin/bash
# Usage: Fix weird shapes in dissolvedShapes 2011 and 2012 folders
shopt -s nullglob
for f in dissolvedShapes/20**/*Dissolve.geojson
do
  filename="${f%.*}"
  echo "Cleaning up shapes for - $filename"
  ogr2ogr -f GeoJSON -Lco COORDINATE_PRECISION=12 "$filename"simple.geojson "$filename".geojson
  ogr2ogr -f GeoJSON -Lco COORDINATE_PRECISION=12 "$filename"ssimple.geojson "$filename"simple.geojson -dialect sqlite -sql "SELECT PrecinctID, CountyID, ST_SimplifyPreserveTopology(geometry, 0.0001) as geometry FROM OGRGeoJSON"
  ogr2ogr -f GeoJSON -Lco COORDINATE_PRECISION=12 "$filename"clean.geojson "$filename"ssimple.geojson -dialect sqlite -sql "SELECT PrecinctID, CountyID, ST_MakeValid(geometry) as geometry FROM OGRGeoJSON"
  rm "$filename"simple.geojson
  rm "$filename"ssimple.geojson
done
