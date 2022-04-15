


use  `powermail`;

-- --------------------------------------------------------

--
-- Table structure for table `admin`
--

CREATE TABLE IF NOT EXISTS `admin` (
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `superadmin` tinyint(1) NOT NULL DEFAULT '0',
  `created` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `modified` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `active` tinyint(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Virtual Admins';

--
-- Dumping data for table `admin`
--

-- INSERT INTO `admin` (`username`, `password`, `superadmin`, `created`, `modified`, `active`) VALUES('support@powermail.mydomainname.com', 'change_me_ipx', 1, '2016-12-26 12:23:03', '2016-12-26 12:23:03', 1);

-- --------------------------------------------------------

--
-- Table structure for table `alias`
--

CREATE TABLE IF NOT EXISTS `alias` (
  `address` varchar(255) NOT NULL,
  `goto` text NOT NULL,
  `domain` varchar(255) NOT NULL,
  `created` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `modified` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `active` tinyint(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Virtual Aliases';

--
-- Dumping data for table `alias`
--


-- --------------------------------------------------------

--
-- Table structure for table `alias_domain`
--

CREATE TABLE IF NOT EXISTS `alias_domain` (
  `alias_domain` varchar(255) NOT NULL,
  `target_domain` varchar(255) NOT NULL,
  `created` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `modified` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `active` tinyint(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Domain Aliases';

-- --------------------------------------------------------

--
-- Table structure for table `config`
--

CREATE TABLE IF NOT EXISTS `config` (
`id` int(11) NOT NULL,
  `name` varchar(20) NOT NULL DEFAULT '',
  `value` varchar(20) NOT NULL DEFAULT ''
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1 COMMENT='settings';

--
-- Dumping data for table `config`
--

INSERT INTO `config` (`id`, `name`, `value`) VALUES(1, 'version', '1835');

-- --------------------------------------------------------

--
-- Table structure for table `domain`
--

CREATE TABLE IF NOT EXISTS `domain` (
  `domain` varchar(255) NOT NULL,
  `description` varchar(255) CHARACTER SET utf8 NOT NULL,
  `aliases` int(10) NOT NULL DEFAULT '0',
  `mailboxes` int(10) NOT NULL DEFAULT '0',
  `maxquota` bigint(20) NOT NULL DEFAULT '0',
  `quota` bigint(20) NOT NULL DEFAULT '0',
  `transport` varchar(255) NOT NULL,
  `backupmx` tinyint(1) NOT NULL DEFAULT '0',
  `created` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `modified` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `active` tinyint(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Virtual Domains';

--
-- Dumping data for table `domain`
--


-- --------------------------------------------------------

--
-- Table structure for table `domain_admins`
--

CREATE TABLE IF NOT EXISTS `domain_admins` (
  `username` varchar(255) NOT NULL,
  `domain` varchar(255) NOT NULL,
  `created` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `active` tinyint(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Domain Admins';

--
-- Dumping data for table `domain_admins`
--

INSERT INTO `domain_admins` (`username`, `domain`, `created`, `active`) VALUES('support@technoinfotech.com', 'ALL', '2016-12-26 12:23:03', 1);

-- --------------------------------------------------------

--
-- Table structure for table `fetchmail`
--

CREATE TABLE IF NOT EXISTS `fetchmail` (
`id` int(11) unsigned NOT NULL,
  `domain` varchar(255) DEFAULT '',
  `mailbox` varchar(255) NOT NULL,
  `src_server` varchar(255) NOT NULL,
  `src_auth` enum('password','kerberos_v5','kerberos','kerberos_v4','gssapi','cram-md5','otp','ntlm','msn','ssh','any') DEFAULT NULL,
  `src_user` varchar(255) NOT NULL,
  `src_password` varchar(255) NOT NULL,
  `src_folder` varchar(255) NOT NULL,
  `poll_time` int(11) unsigned NOT NULL DEFAULT '10',
  `fetchall` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `keep` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `protocol` enum('POP3','IMAP','POP2','ETRN','AUTO') DEFAULT NULL,
  `usessl` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `sslcertck` tinyint(1) NOT NULL DEFAULT '0',
  `sslcertpath` varchar(255) CHARACTER SET utf8 DEFAULT '',
  `sslfingerprint` varchar(255) DEFAULT '',
  `extra_options` text,
  `returned_text` text,
  `mda` varchar(255) NOT NULL,
  `date` timestamp NOT NULL DEFAULT '2000-01-01 00:00:00',
  `created` timestamp NOT NULL DEFAULT '2000-01-01 00:00:00',
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `active` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `log`
--

CREATE TABLE IF NOT EXISTS `log` (
  `timestamp` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `username` varchar(255) NOT NULL,
  `domain` varchar(255) NOT NULL,
  `action` varchar(255) NOT NULL,
  `data` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Log';

--
-- Dumping data for table `log`
--


-- --------------------------------------------------------

--
-- Table structure for table `mailbox`
--

CREATE TABLE IF NOT EXISTS `mailbox` (
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `name` varchar(255) CHARACTER SET utf8 NOT NULL,
  `maildir` varchar(255) NOT NULL,
  `quota` bigint(20) NOT NULL DEFAULT '0',
  `local_part` varchar(255) NOT NULL,
  `domain` varchar(255) NOT NULL,
  `created` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `modified` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `active` tinyint(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Virtual Mailboxes';

--
-- Dumping data for table `mailbox`
--


-- --------------------------------------------------------

--
-- Table structure for table `quota`
--

CREATE TABLE IF NOT EXISTS `quota` (
  `username` varchar(255) NOT NULL,
  `path` varchar(100) NOT NULL,
  `current` bigint(20) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `quota2`
--

CREATE TABLE IF NOT EXISTS `quota2` (
  `username` varchar(100) NOT NULL,
  `bytes` bigint(20) NOT NULL DEFAULT '0',
  `messages` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `vacation`
--

CREATE TABLE IF NOT EXISTS `vacation` (
  `email` varchar(255) NOT NULL,
  `subject` varchar(255) CHARACTER SET utf8 NOT NULL,
  `body` text CHARACTER SET utf8 NOT NULL,
  `activefrom` timestamp NOT NULL DEFAULT '2000-01-01 00:00:00',
  `activeuntil` timestamp NOT NULL DEFAULT '2000-01-01 00:00:00',
  `cache` text NOT NULL,
  `domain` varchar(255) NOT NULL,
  `interval_time` int(11) NOT NULL DEFAULT '0',
  `created` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `active` tinyint(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT=' Virtual Vacation Disabled';

-- --------------------------------------------------------

--
-- Table structure for table `vacation_notification`
--

CREATE TABLE IF NOT EXISTS `vacation_notification` (
  `on_vacation` varchar(255) CHARACTER SET latin1 NOT NULL,
  `notified` varchar(255) CHARACTER SET latin1 NOT NULL,
  `notified_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Vacation Notifications Disabled';

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admin`
--
ALTER TABLE `admin`
 ADD PRIMARY KEY (`username`);

--
-- Indexes for table `alias`
--
ALTER TABLE `alias`
 ADD PRIMARY KEY (`address`), ADD KEY `domain` (`domain`);

--
-- Indexes for table `alias_domain`
--
ALTER TABLE `alias_domain`
 ADD PRIMARY KEY (`alias_domain`), ADD KEY `active` (`active`), ADD KEY `target_domain` (`target_domain`);

--
-- Indexes for table `config`
--
ALTER TABLE `config`
 ADD PRIMARY KEY (`id`), ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `domain`
--
ALTER TABLE `domain`
 ADD PRIMARY KEY (`domain`), ADD KEY `active` (`active`);

--
-- Indexes for table `domain_admins`
--
ALTER TABLE `domain_admins`
 ADD KEY `username` (`username`);

--
-- Indexes for table `fetchmail`
--
ALTER TABLE `fetchmail`
 ADD PRIMARY KEY (`id`);

--
-- Indexes for table `log`
--
ALTER TABLE `log`
 ADD KEY `timestamp` (`timestamp`), ADD KEY `domain_timestamp` (`domain`,`timestamp`);

--
-- Indexes for table `mailbox`
--
ALTER TABLE `mailbox`
 ADD PRIMARY KEY (`username`), ADD KEY `domain` (`domain`), ADD KEY `active` (`active`);

--
-- Indexes for table `quota`
--
ALTER TABLE `quota`
 ADD PRIMARY KEY (`username`,`path`);

--
-- Indexes for table `quota2`
--
ALTER TABLE `quota2`
 ADD PRIMARY KEY (`username`);

--
-- Indexes for table `vacation`
--
ALTER TABLE `vacation`
 ADD PRIMARY KEY (`email`), ADD KEY `email` (`email`);

--
-- Indexes for table `vacation_notification`
--
ALTER TABLE `vacation_notification`
 ADD PRIMARY KEY (`on_vacation`,`notified`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `config`
--
ALTER TABLE `config`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT for table `fetchmail`
--
ALTER TABLE `fetchmail`
MODIFY `id` int(11) unsigned NOT NULL AUTO_INCREMENT;
--
-- Constraints for dumped tables
--

--
-- Constraints for table `vacation_notification`
--
ALTER TABLE `vacation_notification`
ADD CONSTRAINT `vacation_notification_pkey` FOREIGN KEY (`on_vacation`) REFERENCES `vacation` (`email`) ON DELETE CASCADE;

