# osm2gmap

*osm2gmap*: This script downloads a current database extract of the OpenStreetMap project from the servers of the Geofabrik GmbH. Here, Germany is set as default. Calling the programs *osmconvert* and *mkgmap*, it then converts the data into Garmin's internal map format for use with compatible navigational devices. The procedure repeats until the map *gmapsupp.img* has been successfully generated.

## Installation

To install all prerequisites, run the following commands in the directory where the script *osm2gmap* is located. This is by default the directory where the command `git clone https://.../osm2gmap.git` has been executed.

If downloading of *splitter* and/or *mkgmap* fails, check the website for a current version. In this case, adjust the following file names accordingly.

``` bash
sudo aptitude install git
sudo aptitude install gcc zlib1g-dev

git clone https://github.com/cclemens1978/osm2gmap.git

mkdir --parents osmconvert/ mkgmap/lib/

cd osmconvert/

wget http://m.m.i24.cc/osmconvert.c
gcc osmconvert.c -lz -O3 -o osmconvert

cd ../mkgmap/

wget https://www.mkgmap.org.uk/download/splitter-r597.tar.gz
tar -zxf splitter-r597.tar.gz splitter-r597/splitter.jar --strip-components=1

wget https://www.mkgmap.org.uk/download/mkgmap-r4565.tar.gz
tar -zxf mkgmap-r4565.tar.gz mkgmap-r4565/mkgmap.jar --strip-components=1
tar -zxf mkgmap-r4565.tar.gz mkgmap-r4565/lib/fastutil-6.5.15-mkg.1b.jar --strip-components=1
tar -zxf mkgmap-r4565.tar.gz mkgmap-r4565/lib/osmpbf-1.3.3.jar --strip-components=1
```

## Usage

``` bash
bash osm2gmap.bash
```

After a while, the newly created map *gmapsupp.img* appears in the subdirectory *mkgmap/* and can be copied to a GPS device.

## Support and Team

Send your suggestions and bug reports to Christian Clemens <<christian.clemens@web.de>>.

## Acknowledgements

This script makes use of software developed by Markus Weber ([osmconvert](https://wiki.openstreetmap.org/wiki/Osmconvert)) and the team of [mkgmap](https://www.mkgmap.org.uk/).

## License

tbd
