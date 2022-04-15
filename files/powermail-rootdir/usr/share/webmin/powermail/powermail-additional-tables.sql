

use powermail;

CREATE TABLE `powerlastpass` (
  `uid` int(11) NOT NULL,
  `username` varchar(250) NOT NULL,
  `last_pass` varchar(250) NOT NULL,
  `last_time` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


CREATE TABLE `powermailbox` (
  `username` varchar(255) NOT NULL,
  `autoclean_trash` int(11) NOT NULL DEFAULT '0',
  `autoclean_spam` int(11) NOT NULL DEFAULT '0',
  `autoclean_promo` int(11) NOT NULL DEFAULT '0',
  `change_pass_max_days` int(11) NOT NULL DEFAULT '0',
  `change_pass_alerts_before_days` int(11) NOT NULL DEFAULT '0',
  `lastlogintime` datetime NOT NULL,
  `lastloginip` varchar(250) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Virtual Mailboxes';


CREATE TABLE `powermaillist` (
  `address` varchar(255) NOT NULL,
  `info` varchar(250) NOT NULL,
  `member` text NOT NULL,
  `owner` text NOT NULL,
  `domain` varchar(255) NOT NULL,
  `created` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `modified` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `sendtype` enum('ANYONE','MEMBERS','OWNERS','MEMBERS_AND_OWNERS') NOT NULL DEFAULT 'ANYONE'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Virtual Aliases';


CREATE TABLE `powerweakpass` (
  `uid` int(11) NOT NULL,
  `weakpass` varchar(250) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

ALTER TABLE `powerlastpass`
  ADD PRIMARY KEY (`uid`),
  ADD KEY `username` (`username`(191)),
  ADD KEY `last_pass` (`last_pass`(191));

ALTER TABLE `powermailbox`
  ADD PRIMARY KEY (`username`),
  ADD KEY `autoclean_trash` (`autoclean_trash`),
  ADD KEY `autoclean_promo` (`autoclean_promo`),
  ADD KEY `autoclean_spam` (`autoclean_spam`) USING BTREE,
  ADD KEY `change_pass_max_days` (`change_pass_max_days`),
  ADD KEY `change_pass_alerts_before_days` (`change_pass_alerts_before_days`);

ALTER TABLE `powermaillist`
  ADD PRIMARY KEY (`address`),
  ADD KEY `domain` (`domain`);

ALTER TABLE `powerweakpass`
  ADD PRIMARY KEY (`uid`),
  ADD UNIQUE KEY `weakpass` (`weakpass`(191)) USING BTREE;


