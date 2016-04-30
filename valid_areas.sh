#!/bin/bash
# Usage: Fix weird shapes in Districts folder
shopt -s nullglob
mkdir Districts/cleaned
rm Districts/cleaned/*
for f in Districts/*.geojson
do
  filename="${f%.*}"
  echo "Cleaning up shapes for - $filename"
  ogr2ogr -f GeoJSON -Lco COORDINATE_PRECISION=12 "$filename"simple.geojson "$filename".geojson 
  ogr2ogr -f GeoJSON -Lco COORDINATE_PRECISION=12 "$filename"clean.geojson "$filename"simple.geojson -dialect sqlite -sql "SELECT *, ST_MakeValid(geometry) as geometry FROM OGRGeoJSON"
  rm "$filename"simple.geojson
done
mv Districts/*clean.geojson Districts/cleaned/