#!/bin/sh

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

SCRIPTDIR="$(pwd)"

#### Make Directories ####
echo "Making Directories"
mkdir -p /data/apache/lib/perl/Apache
mkdir /data/apache/sites
mkdir /data/apache/base
mkdir /data/apache/session
mkdir /data/apache/logs

# Make session directory for your app
# mkdir /data/apache/session/<my_app>


#### Directory Permissions ####
echo "Setting directory Permissions"
chmod -R 755 /data/apache
chown -R apache:root /data/apache
chown -R apache:apache /data/apache/lib/perl
chown -R apache:apache /data/apache/session/*


#### System Packages ####
echo "Installing system packages"
yum install curl-devel
yum install libxml2
yum install perl-libapreq2
yum install expat-devel
yum install htmldoc

#### System Perl Modules ####
echo "Installing system perl modules"
yum install perl-DBI
yum install perl-DBD-MySQL
yum install perl-IPC-SharedCache
yum install perl-Package-Stash
yum install perl-AnyEvent
yum install perl-Crypt-SSLeay
yum install perl-IO-Socket-SSL
yum install perl-DBD-SQLite
yum install perl-Math-Pari


####  Install App::Cpanminus ####
echo "Installing Cpanminus"
cd /bin
curl -LO http://xrl.us/cpanm
chmod +x cpanm
cd $SCRIPTDIR

#### Install CPAN Modules ####
echo "Installing CPAN modules"
./voodoo_perl_modules.sh

#### Change Permissions on Perl libraries so the Apache user can use them ####


find /usr/local/lib64/perl5 -type d -exec chmod 755 {} \;
find /usr/local/lib64/perl5 -name "*.pm" -exec chmod 744 {} \;

find /usr/local/share/perl5 -type d -exec chmod 755 {} \;
find /usr/local/share/perl5 -name "*.pm" -exec chmod 744 {} \;

find /usr/lib64/perl5 -type d -exec chmod 755 {} \;
find /usr/lib64/perl5 -name "*.pm" -exec chmod 744 {} \;


#### Copy Apache::Voodoo

# Fetch 2.0400
curl -LO http://search.cpan.org/CPAN/authors/id/M/MA/MAVERICK/Apache-Voodoo-2.0400.tar.gz

# Unpack
tar -xzvf ./Apache-Voodoo-2.0400.tar.gz

# Move it to where it belongs
mv ./Apache-Voodoo-2.0400/lib/Apache /data/apache/lib/perl/

# Cleanup
rm -rf Apache-Voodoo-2.0400.tar.gz
rm -rf Apache-Voodoo-2.0400

# Change owner/permissions
chmod -R 755 /data/apache/lib/perl
chown -R apache:apache /data/apache/lib/perl


# Finish
echo "Run the appropriate <application>_intall.sh"

exit

1;