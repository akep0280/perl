class perl::config {
	include apache

	
	exec { 'perl_prereg_install.sh'}
}