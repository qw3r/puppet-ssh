class ssh {
	define ssh::allow_users($allow_users = false) {
		$t_allow_users = $allow_users ? {
			false => [],
			default => $allow_users,
		}

		file { "$name":
		    owner   => root,
		    group   => root,
		    mode    => 0644,
		    alias   => "sshd_config",
		    source  => "puppet:///modules/ssh/${::lsbdistcodename}/etc/ssh/sshd_config",
		    notify  => Service["ssh"],
		    require => Package["openssh-server"],
		}
	}
	
	ssh::allow_users { "/etc/ssh/sshd_config":
	    allow_users => hiera('allow_users'),
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

