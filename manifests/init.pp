class ssh {
	file { "/etc/ssh/sshd_config":
		owner   => root,
		group   => root,
		mode    => 0644,
		alias   => "sshd_config",
		source  => "puppet:///modules/ssh/${::lsbdistcodename}/etc/ssh/sshd_config",
		notify  => Service["ssh"],
		require => Package["openssh-server"],
	}

	file { "/root/.ssh":
		force   => true,
		purge   => true,
		recurse => true,
		owner   => root,
		group   => root,
		mode    => 0600, 
		source  => "puppet:///modules/ssh/common/root/.ssh/${::hostname}",
	}

	package { "openssh-server":
		ensure => present,
	}

	service { "ssh":
		enable     => true,
		ensure     => running,
		hasrestart => true,
		hasstatus  => true,
		require    => [
			File["sshd_config"],
			Package["openssh-server"]
		],
	}
}

# vim: tabstop=3