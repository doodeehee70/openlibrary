#! /bin/bash
# script to install all required software on OL nodes

# create OL folders
echo "creating folders..."

OL_FOLDERS="/0/pharos /1/pharos /2/pharos /3/pharos"
mkdir -p $OL_FOLDERS
chgrp  pharos $OL_FOLDERS
chmod g+w $OL_FOLDERS

echo "installing apt-get packages..."
aptitude install         \
    git-core            \
    sqlite3             \
    python-dev          \
    python-setuptools   \
    python-imaging      \
    python-psycopg2     \
    python-mysqldb      \
    python-yaml

echo "removing troublesome modules"
aptitude remove yaz

echo "installing python packages..."
easy_install -Z \
    simplejson  \
    pymarc      \
    web.py      \
    flup        \
    subcommand

# setup code
echo "getting openlibrary code..."
dirs="/0/pharos/code /0/pharos/scripts /0/pharos/services /0/pharos/etc"
mkdir -p $dirs
chmod g+w $dirs
cd /0/pharos/code
git clone git://github.com/openlibrary/openlibrary.git

# fix lighttpd-angel hack used by petabox

sudo lighttpd-disable-mod petabox
sed 's,/petabox/sw/lighttpd/lighttpd-angel,/usr/sbin/lighttpd,' /etc/init.d/lighttpd > /tmp/lighttpd.$$
rm /etc/init.d/lighttpd # remove symlink to petabox
mv /tmp/lighttpd.$$ /etc/init.d/lighttpd
chmod +x /etc/init.d/lighttpd

mv /etc/lighttpd /etc/lighttpd.orig
ln -s /olsystem/etc/lighttpd /etc/lighttpd

# setup oldirs

oldirs=                         \
    /var/cache/openlibrary      \
    /0/pharos/data              \
    /1/pharos/data

mkdir $oldirs
chown openlibrary:openlibrary $oldirs
