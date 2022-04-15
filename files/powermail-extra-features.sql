-- phpMyAdmin SQL Dump
-- version 4.6.6deb4
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Jun 11, 2019 at 03:03 PM
-- Server version: 10.1.38-MariaDB-0+deb9u1
-- PHP Version: 7.0.33-0+deb9u3

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

use powermail;
--
-- Database: `powermail`
--

-- --------------------------------------------------------

--
-- Table structure for table `powerlastpass`
--

CREATE TABLE `powerlastpass` (
  `uid` int(11) NOT NULL,
  `username` varchar(250) NOT NULL,
  `last_pass` varchar(250) NOT NULL,
  `last_time` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `powermailbox`
--


-- --------------------------------------------------------

--
-- Table structure for table `powermaillist`
--

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

-- --------------------------------------------------------

--
-- Table structure for table `powerweakpass`
--

CREATE TABLE `powerweakpass` (
  `uid` int(11) NOT NULL,
  `weakpass` varchar(250) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `powerlastpass`
--
ALTER TABLE `powerlastpass`
  ADD PRIMARY KEY (`uid`),
  ADD KEY `username` (`username`(191)),
  ADD KEY `last_pass` (`last_pass`(191));

--

--
-- Indexes for table `powermaillist`
--
ALTER TABLE `powermaillist`
  ADD PRIMARY KEY (`address`),
  ADD KEY `domain` (`domain`);

--
-- Indexes for table `powerweakpass`
--
ALTER TABLE `powerweakpass`
  ADD PRIMARY KEY (`uid`),
  ADD UNIQUE KEY `weakpass` (`weakpass`(191)) USING BTREE;



/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;


--
-- Table structure for table `powermailbox`
--

CREATE TABLE `powermailbox` (
  `username` varchar(255) NOT NULL,
  `autoclean_trash` int(11) NOT NULL DEFAULT 0,
  `autoclean_spam` int(11) NOT NULL DEFAULT 0,
  `autoclean_promo` int(11) NOT NULL DEFAULT 0,
  `change_pass_max_days` int(11) NOT NULL DEFAULT 0,
  `change_pass_alerts_before_days` int(11) NOT NULL DEFAULT 0,
  `lastlogintime` int(11) NOT NULL,
  `lastloginip` varchar(250) NOT NULL,
  `deliveryto` varchar(5) NOT NULL DEFAULT 'local'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Virtual Mailboxes';

--
-- Indexes for dumped tables
--

--
-- Indexes for table `powermailbox`
--
ALTER TABLE `powermailbox`
  ADD PRIMARY KEY (`username`),
  ADD KEY `autoclean_trash` (`autoclean_trash`),
  ADD KEY `autoclean_promo` (`autoclean_promo`),
  ADD KEY `autoclean_spam` (`autoclean_spam`) USING BTREE,
  ADD KEY `change_pass_max_days` (`change_pass_max_days`),
  ADD KEY `change_pass_alerts_before_days` (`change_pass_alerts_before_days`),
  ADD KEY `lastlogintime` (`lastlogintime`),
  ADD KEY `lastloginip` (`lastloginip`),
  ADD KEY `deliveryto` (`deliveryto`);

ALTER TABLE `powermailbox` CHANGE `lastlogintime` `lastlogintime` INT(11) NULL;
ALTER TABLE `powermailbox` CHANGE `lastloginip` `lastloginip` VARCHAR(250) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL;
ALTER TABLE `powermailbox` CHANGE `deliveryto` `deliveryto` VARCHAR(10) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT 'local';

COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

