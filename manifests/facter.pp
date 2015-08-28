class perl::facter {
	#Create custom facter for perl install
	file { "/etc/puppetlabs/facter/facts.d/perl_facter.sh":
		source => "puppet:///modules/perl/perl_facter.sh",
		mode   => "0700",
		owner  => "root",
		}
}