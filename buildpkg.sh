#!/bin/sh

distro=$1

DIE=0

echo "deb directory..."
(mkdir deb ) > /dev/null || {
	echo "cleaning..."

	(rm -Rf deb/*) > /dev/null || {
	  echo
	  echo "**Error**: removing error ."
	  echo ""
	  exit 1
	}
}



echo "making distribution source file..."
(make dist) > /dev/null || {
  echo
  echo "**Error**: make dist ."
  echo ""
  exit 1
}


echo "copying..."

(mv moldeoplugins-particlesfractal-*.tar.gz ./deb/) > /dev/null || {
  echo
  echo "**Error**: moving file ."
  echo ""
  exit 1
}


echo "renaming..."
( rename 's/\.tar.gz/\.orig.tar.gz/' deb/*.tar.gz ) > /dev/null || {
  echo
  echo "**Error**: renaming ."
  echo ""
  exit 1
}
( rename 's/\-1/\_1/' deb/*.tar.gz ) > /dev/null || {
  echo
  echo "**Error**: renaming ."
  echo ""
  exit 1
}


echo "extracting..."

(tar -C deb -zxvf ./deb/*.orig.tar.gz ) > /dev/null || {
  echo
  echo "**Error**: extracting ."
  echo ""
  exit 1
}

cd deb/moldeoplugins-*-*
dh_make -l -e info@moldeointeractive.com.ar -p moldeoplugins-particlesfractal

echo "Success: Extraction"

sed -i -e 's/Architecture: any/Architecture: amd64/g' debian/control
sed -i -e 's/Section: unknown/Section: graphics/g' debian/control
sed -i -e 's/Maintainer: fabricio /Maintainer: Moldeo Interactive /g' debian/control
sed -i -e 's/<insert the upstream URL, if relevant>/http:\\\\www.moldeo.org/g' debian/control
sed -i -e 's/moldeoplugins-particlesfractalBROKEN/moldeoplugins-particlesfractal/g' debian/control
#with opencv
#sed -i -e 's/,autotools-dev/, autotools-dev, libmoldeo-dev, libopencv-dev, libportmidi-dev, libsndfile1-dev/g' debian/control
sed -i -e 's/,autotools-dev/, autotools-dev, libmoldeo-dev, libportmidi-dev, libsndfile1-dev/g' debian/control

#development
sed -i -e '0,/, ${misc:Depends}/{s/, ${misc:Depends}/,${misc:Depends}, libmoldeo-dev, libopencv-dev, libportmidi-dev, libsndfile1-dev/g}' debian/control
sed -i -e '0,/<insert up to 60 chars description>/{s/<insert up to 60 chars description>/Particles Fractal, Moldeo Plugin, Dev Package/}'  debian/control

#binary
#with OpenCV
#sed -i -e 's/, ${misc:Depends}/,${misc:Depends},  libmoldeo-dev, libopencv-dev, libportmidi-dev, libsndfile1-dev/g' debian/control
sed -i -e 's/, ${misc:Depends}/,${misc:Depends},  libmoldeo-dev, libportmidi-dev, libsndfile1-dev/g' debian/control
sed -i -e 's/<insert up to 60 chars description>/Particles Fractal, Moldeo Plugin/'  debian/control
sed -i -e 's/<insert long description, indented with spaces>/Particles Fractal, Moldeo Plugin for Moldeo Software Platform/g'  debian/control

sed -i -e 's/unstable/experimental/g' debian/changelog
sed -i -e 's/\-1/\-1'${distro}'/g' debian/changelog
sed -i -e 's/fabricio/Moldeo Interactive/g' debian/changelog
sed -i -e 's/Initial release (Closes: #nnnn)  <nnnn is the bug number of your ITP>/Initial release/g' debian/changelog
#sed -i -e 's///g'  debian/control
#
#sed -i -e 's///g' debian/control

echo "usr/lib" > debian/moldeoplugins-particlesfractal.dirs
echo "usr/lib/moldeo" >> debian/moldeoplugins-particlesfractal.dirs
#echo "usr/lib/moldeo/preeffects" >> debian/moldeoplugins.dirs
echo "usr/lib/moldeo/effects" >> debian/moldeoplugins-particlesfractal.dirs
#echo "usr/lib/moldeo/posteffects" >> debian/moldeoplugins.dirs
#echo "usr/lib/moldeo/mastereffects" >> debian/moldeoplugins.dirs
#echo "usr/lib/moldeo/iodevices" >> debian/moldeoplugins.dirs
#echo "usr/lib/moldeo/resources" >> debian/moldeoplugins.dirs

#echo "usr/lib/moldeo/preeffects/lib*.so.*" > debian/moldeoplugins.install
echo "usr/lib/moldeo/effects/lib*.so.*" >> debian/moldeoplugins-particlesfractal.install
#echo "usr/lib/moldeo/posteffects/lib*.so.*" >> debian/moldeoplugins.install
#echo "usr/lib/moldeo/mastereffects/lib*.so.*" >> debian/moldeoplugins.install
#echo "usr/lib/moldeo/iodevices/lib*.so.*" >> debian/moldeoplugins.install
#echo "usr/lib/moldeo/resources/lib*.so.*" >> debian/moldeoplugins.install
#echo "usr/lib/moldeo/preeffects/lib*.so" >> debian/moldeoplugins.install
echo "usr/lib/moldeo/effects/lib*.so" >> debian/moldeoplugins-particlesfractal.install
#echo "usr/lib/moldeo/posteffects/lib*.so" >> debian/moldeoplugins.install
#echo "usr/lib/moldeo/mastereffects/lib*.so" >> debian/moldeoplugins.install
#echo "usr/lib/moldeo/iodevices/lib*.so" >> debian/moldeoplugins.install
#echo "usr/lib/moldeo/resources/lib*.so" >> debian/moldeoplugins.install

echo "usr/lib" > debian/moldeoplugins-particlesfractal-dev.dirs
echo "usr/lib/moldeo" >> debian/moldeoplugins-particlesfractal-dev.dirs
#echo "usr/lib/moldeo/preeffects" >> debian/moldeoplugins-dev.dirs
echo "usr/lib/moldeo/effects" >> debian/moldeoplugins-particlesfractal-dev.dirs
#echo "usr/lib/moldeo/posteffects" >> debian/moldeoplugins-dev.dirs
#echo "usr/lib/moldeo/mastereffects" >> debian/moldeoplugins-dev.dirs
#echo "usr/lib/moldeo/iodevices" >> debian/moldeoplugins-dev.dirs
#echo "usr/lib/moldeo/resources" >> debian/moldeoplugins-dev.dirs
echo "usr/include" > debian/moldeoplugins-particlesfractal-dev.dirs
echo "usr/include/moldeo" >> debian/moldeoplugins-particlesfractal-dev.dirs
#echo "usr/include/moldeo/preeffects" >> debian/moldeoplugins-dev.dirs
echo "usr/include/moldeo/effects" >> debian/moldeoplugins-particlesfractal-dev.dirs
#echo "usr/include/moldeo/posteffects" >> debian/moldeoplugins-dev.dirs
#echo "usr/include/moldeo/mastereffects" >> debian/moldeoplugins-dev.dirs
#echo "usr/include/moldeo/iodevices" >> debian/moldeoplugins-dev.dirs
#echo "usr/include/moldeo/resources" >> debian/moldeoplugins-dev.dirs


#echo "usr/lib/moldeo/preeffects/lib*.a" > debian/moldeoplugins-dev.install
echo "usr/lib/moldeo/effects/lib*.a" > debian/moldeoplugins-particlesfractal-dev.install
#echo "usr/lib/moldeo/posteffects/lib*.a" >> debian/moldeoplugins-dev.install
#echo "usr/lib/moldeo/mastereffects/lib*.a" >> debian/moldeoplugins-dev.install
#echo "usr/lib/moldeo/iodevices/lib*.a" >> debian/moldeoplugins-dev.install
#echo "usr/lib/moldeo/resources/lib*.a" >> debian/moldeoplugins-dev.install

#echo "usr/lib/moldeo/preeffects/lib*.la" >> debian/moldeoplugins-dev.install
echo "usr/lib/moldeo/effects/lib*.la" >> debian/moldeoplugins-particlesfractal-dev.install
#echo "usr/lib/moldeo/posteffects/lib*.la" >> debian/moldeoplugins-dev.install
#echo "usr/lib/moldeo/mastereffects/lib*.la" >> debian/moldeoplugins-dev.install
#echo "usr/lib/moldeo/iodevices/lib*.la" >> debian/moldeoplugins-dev.install
#echo "usr/lib/moldeo/resources/lib*.la" >> debian/moldeoplugins-dev.install
#echo "usr/include/moldeo/preeffects/*" >> debian/moldeoplugins-dev.install

#xed ../../control.amd64.11.10 debian/control ../../moldeoplugins1.dirs.amd64 debian/moldeoplugins.dirs ../../moldeoplugins1.install.amd64 debian/moldeoplugins.install ../../moldeoplugins-dev.dirs.amd64 debian/moldeoplugins-dev.dirs ../../moldeoplugins-dev.install.amd64 debian/moldeoplugins-dev.install debian/changelog
xed debian/control debian/changelog debian/moldeoplugins-particlesfractal.dirs debian/moldeoplugins-particlesfractal.install debian/moldeoplugins-particlesfractal-dev.install

dpkg-buildpackage -us -uc -rfakeroot 2>&1 | tee ../../buildpkg_logs.txt



echo "Success: packaging"

exit 0
