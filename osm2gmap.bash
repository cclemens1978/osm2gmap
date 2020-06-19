#!/usr/bin/env bash

# check if all tools are installed correctly
for FILE in osmconvert/osmconvert \
  mkgmap/splitter.jar \
  mkgmap/mkgmap.jar \
  mkgmap/lib/fastutil-6.5.15-mkg.1b.jar \
  mkgmap/lib/osmpbf-1.3.3.jar; do
    if ! test -f "${FILE}"; then
      echo "${FILE} does not exist."
      exit
    fi
done

# change to existing working directory
cd mkgmap/

#
## download and process map (Germany)

until test -f gmapsupp.img; do

  # clean up working directory
  rm -vf densities-out.txt areas.* template.args problems.list 6324*.o5m 6324*.img ovm_6324*.img osmmap.*

  # date
  IDX=$(date +%Y-%m-%d)

  # wget and osmconvert
  mkdir --parents ../maps/
  wget --tries=0 --output-document=- http://download.geofabrik.de/europe/germany-latest.osm.pbf | \
    ../osmconvert/osmconvert - --out-osm | \
    bzip2 --best > "../maps/germany_${IDX}.osm.bz2"

  # splitter.jar
  java -Xmx2048M -jar splitter.jar \
    --problem-report=problems.list \
    --write-kml=areas.kml \
    --output=o5m \
    "../maps/germany_${IDX}.osm.bz2"

  # mkgmap.jar
  java -Xmx2048M -jar mkgmap.jar \
    --country-name=GERMANY \
    --country-abbr=D \
    --latin1 \
    --route \
    --gmapsupp \
    --read-config=template.args

  # clean up working directory
  rm -vf 6324*.o5m 6324*.img ovm_6324*.img osmmap.*

done
