#!/bin/bash
# Usage: Fix weird shapes in dissolvedShapes 2011 and 2012 folders
shopt -s nullglob
for f in dissolvedShapes/20**/*Dissolve.geojson
do
  filename="${f%.*}"
  echo "Cleaning up shapes for - $filename"
  ogr2ogr -f GeoJSON -Lco COORDINATE_PRECISION=12 "$filename"clean.geojson "$filename".geojson -dialect sqlite -sql "SELECT PrecinctID, CountyID, ST_MakeValid(geometry) as geometry FROM OGRGeoJSON"
done
