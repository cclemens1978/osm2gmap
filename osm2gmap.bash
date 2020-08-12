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
## download and process map of Germany

until test -f gmapsupp.img; do

  # clean up working directory
  rm --verbose --force densities-out.txt areas.* template.args problems.list 6324*.o5m 6324*.img ovm_6324*.img osmmap.*

  # query date
  IDX=$(date +%Y-%m-%d)

  # create map directory
  mkdir --parents ../maps/

  # uncomment these two lines and comment the following three lines if you want to use a map downloaded in advance, e.g. from the internal password-protected area of the Geofabrik GmbH

  # # use a map of Germany downloaded in advance
  # TMPFILE="/tmp/germany-latest-internal.osm.pbf"

  # download current map of Germany
  TMPFILE="$(mktemp --tmpdir=/dev/shm/)"
  wget --output-document="${TMPFILE}" https://download.geofabrik.de/europe/germany-latest.osm.pbf

  # execute osmconvert and bzip2
  ../osmconvert/osmconvert --verbose "${TMPFILE}" --out-osm | \
  bzip2 --best > "../maps/germany_${IDX}.osm.bz2"
  rm --verbose --force "${TMPFILE}"

  # execute splitter.jar
  java -Xmx2048M -jar splitter.jar \
    --problem-report=problems.list \
    --write-kml=areas.kml \
    --output=o5m \
    "../maps/germany_${IDX}.osm.bz2"

  # execute mkgmap.jar
  java -Xmx2048M -jar mkgmap.jar \
    --country-name=GERMANY \
    --country-abbr=D \
    --latin1 \
    --route \
    --gmapsupp \
    --read-config=template.args

  # clean up working directory
  rm --verbose --force 6324*.o5m 6324*.img ovm_6324*.img osmmap.*

done
