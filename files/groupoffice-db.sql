-- MySQL dump 10.17  Distrib 10.3.22-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: groupoffice
-- ------------------------------------------------------
-- Server version	10.3.22-MariaDB-0+deb10u1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `addressbook_address`
--
use groupoffice;

DROP TABLE IF EXISTS `addressbook_address`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `addressbook_address` (
  `contactId` int(11) NOT NULL,
  `type` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `street` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `street2` varchar(190) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `zipCode` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `city` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `state` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `country` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `countryCode` char(2) CHARACTER SET ascii COLLATE ascii_bin DEFAULT NULL COMMENT 'ISO_3166 Alpha 2 code',
  `latitude` decimal(10,8) DEFAULT NULL,
  `longitude` decimal(11,8) DEFAULT NULL,
  KEY `contactId` (`contactId`),
  CONSTRAINT `addressbook_address_ibfk_1` FOREIGN KEY (`contactId`) REFERENCES `addressbook_contact` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `addressbook_address`
--

LOCK TABLES `addressbook_address` WRITE;
/*!40000 ALTER TABLE `addressbook_address` DISABLE KEYS */;
/*!40000 ALTER TABLE `addressbook_address` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `addressbook_addressbook`
--

DROP TABLE IF EXISTS `addressbook_addressbook`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `addressbook_addressbook` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(190) COLLATE utf8mb4_unicode_ci NOT NULL,
  `aclId` int(11) NOT NULL,
  `createdBy` int(11) DEFAULT NULL,
  `filesFolderId` int(11) DEFAULT NULL,
  `salutationTemplate` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `acid` (`aclId`),
  KEY `createdBy` (`createdBy`),
  CONSTRAINT `addressbook_addressbook_ibfk_1` FOREIGN KEY (`aclId`) REFERENCES `core_acl` (`id`),
  CONSTRAINT `addressbook_addressbook_ibfk_2` FOREIGN KEY (`createdBy`) REFERENCES `core_user` (`id`) ON DELETE SET NULL ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `addressbook_addressbook`
--

LOCK TABLES `addressbook_addressbook` WRITE;
/*!40000 ALTER TABLE `addressbook_addressbook` DISABLE KEYS */;
INSERT INTO `addressbook_addressbook` VALUES (1,'Shared',10,1,NULL,'Dear [if {{contact.prefixes}}]{{contact.prefixes}}[else][if !{{contact.gender}}]Ms./Mr.[else][if {{contact.gender}}==\"M\"]Mr.[else]Ms.[/if][/if][/if][if {{contact.middleName}}] {{contact.middleName}}[/if] {{contact.lastName}}'),(2,'Users',30,1,NULL,'Dear [if {{contact.prefixes}}]{{contact.prefixes}}[else][if !{{contact.gender}}]Ms./Mr.[else][if {{contact.gender}}==\"M\"]Mr.[else]Ms.[/if][/if][/if][if {{contact.middleName}}] {{contact.middleName}}[/if] {{contact.lastName}}');
/*!40000 ALTER TABLE `addressbook_addressbook` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `addressbook_contact`
--

DROP TABLE IF EXISTS `addressbook_contact`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `addressbook_contact` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `addressBookId` int(11) NOT NULL,
  `createdBy` int(11) DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `modifiedAt` datetime NOT NULL,
  `modifiedBy` int(11) DEFAULT NULL,
  `goUserId` int(11) DEFAULT NULL,
  `prefixes` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Prefixes like ''Sir''',
  `initials` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `firstName` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `middleName` varchar(55) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `lastName` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `suffixes` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Suffixes like ''Msc.''',
  `salutation` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `gender` enum('M','F') COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'M for Male, F for Female or null for unknown',
  `notes` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `isOrganization` tinyint(1) NOT NULL DEFAULT 0,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'name field for companies and contacts. It should be the display name of first, middle and last name',
  `IBAN` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `registrationNumber` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Company trade registration number',
  `vatNo` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `vatReverseCharge` tinyint(1) NOT NULL DEFAULT 0,
  `debtorNumber` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `photoBlobId` binary(40) DEFAULT NULL,
  `language` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `jobTitle` varchar(190) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `department` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `filesFolderId` int(11) DEFAULT NULL,
  `uid` varchar(512) CHARACTER SET ascii COLLATE ascii_bin DEFAULT NULL,
  `vcardBlobId` binary(40) DEFAULT NULL,
  `uri` varchar(512) CHARACTER SET ascii COLLATE ascii_bin DEFAULT NULL,
  `color` char(6) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `goUserId` (`goUserId`),
  KEY `owner` (`createdBy`),
  KEY `photoBlobId` (`photoBlobId`),
  KEY `addressBookId` (`addressBookId`),
  KEY `modifiedBy` (`modifiedBy`),
  KEY `vcardBlobId` (`vcardBlobId`),
  CONSTRAINT `addressbook_contact_ibfk_1` FOREIGN KEY (`addressBookId`) REFERENCES `addressbook_addressbook` (`id`),
  CONSTRAINT `addressbook_contact_ibfk_2` FOREIGN KEY (`photoBlobId`) REFERENCES `core_blob` (`id`),
  CONSTRAINT `addressbook_contact_ibfk_3` FOREIGN KEY (`modifiedBy`) REFERENCES `core_user` (`id`) ON DELETE SET NULL,
  CONSTRAINT `addressbook_contact_ibfk_4` FOREIGN KEY (`createdBy`) REFERENCES `core_user` (`id`) ON DELETE SET NULL,
  CONSTRAINT `addressbook_contact_ibfk_5` FOREIGN KEY (`goUserId`) REFERENCES `core_user` (`id`) ON DELETE SET NULL,
  CONSTRAINT `addressbook_contact_ibfk_6` FOREIGN KEY (`vcardBlobId`) REFERENCES `core_blob` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `addressbook_contact`
--

LOCK TABLES `addressbook_contact` WRITE;
/*!40000 ALTER TABLE `addressbook_contact` DISABLE KEYS */;
/*!40000 ALTER TABLE `addressbook_contact` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `addressbook_contact_custom_fields`
--

DROP TABLE IF EXISTS `addressbook_contact_custom_fields`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `addressbook_contact_custom_fields` (
  `id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `addressbook_contact_custom_fields_ibfk_1` FOREIGN KEY (`id`) REFERENCES `addressbook_contact` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `addressbook_contact_custom_fields`
--

LOCK TABLES `addressbook_contact_custom_fields` WRITE;
/*!40000 ALTER TABLE `addressbook_contact_custom_fields` DISABLE KEYS */;
/*!40000 ALTER TABLE `addressbook_contact_custom_fields` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `addressbook_contact_group`
--

DROP TABLE IF EXISTS `addressbook_contact_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `addressbook_contact_group` (
  `contactId` int(11) NOT NULL,
  `groupId` int(11) NOT NULL,
  PRIMARY KEY (`contactId`,`groupId`),
  KEY `groupId` (`groupId`),
  CONSTRAINT `addressbook_contact_group_ibfk_1` FOREIGN KEY (`contactId`) REFERENCES `addressbook_contact` (`id`) ON DELETE CASCADE,
  CONSTRAINT `addressbook_contact_group_ibfk_2` FOREIGN KEY (`groupId`) REFERENCES `addressbook_group` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `addressbook_contact_group`
--

LOCK TABLES `addressbook_contact_group` WRITE;
/*!40000 ALTER TABLE `addressbook_contact_group` DISABLE KEYS */;
/*!40000 ALTER TABLE `addressbook_contact_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `addressbook_contact_star`
--

DROP TABLE IF EXISTS `addressbook_contact_star`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `addressbook_contact_star` (
  `contactId` int(11) NOT NULL,
  `userId` int(11) NOT NULL,
  `modSeq` int(11) NOT NULL DEFAULT 0,
  `starred` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`contactId`,`userId`),
  KEY `addressbook_contact_star_ibfk_2` (`userId`),
  CONSTRAINT `addressbook_contact_star_ibfk_1` FOREIGN KEY (`contactId`) REFERENCES `addressbook_contact` (`id`) ON DELETE CASCADE,
  CONSTRAINT `addressbook_contact_star_ibfk_2` FOREIGN KEY (`userId`) REFERENCES `core_user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `addressbook_contact_star`
--

LOCK TABLES `addressbook_contact_star` WRITE;
/*!40000 ALTER TABLE `addressbook_contact_star` DISABLE KEYS */;
/*!40000 ALTER TABLE `addressbook_contact_star` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `addressbook_date`
--

DROP TABLE IF EXISTS `addressbook_date`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `addressbook_date` (
  `contactId` int(11) NOT NULL,
  `type` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'birthday',
  `date` date NOT NULL,
  KEY `contactId` (`contactId`),
  CONSTRAINT `addressbook_date_ibfk_1` FOREIGN KEY (`contactId`) REFERENCES `addressbook_contact` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `addressbook_date`
--

LOCK TABLES `addressbook_date` WRITE;
/*!40000 ALTER TABLE `addressbook_date` DISABLE KEYS */;
/*!40000 ALTER TABLE `addressbook_date` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `addressbook_email_address`
--

DROP TABLE IF EXISTS `addressbook_email_address`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `addressbook_email_address` (
  `contactId` int(11) NOT NULL,
  `type` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  KEY `contactId` (`contactId`),
  CONSTRAINT `addressbook_email_address_ibfk_1` FOREIGN KEY (`contactId`) REFERENCES `addressbook_contact` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `addressbook_email_address`
--

LOCK TABLES `addressbook_email_address` WRITE;
/*!40000 ALTER TABLE `addressbook_email_address` DISABLE KEYS */;
/*!40000 ALTER TABLE `addressbook_email_address` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `addressbook_group`
--

DROP TABLE IF EXISTS `addressbook_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `addressbook_group` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `addressBookId` int(11) NOT NULL,
  `name` varchar(190) CHARACTER SET latin1 NOT NULL,
  PRIMARY KEY (`id`),
  KEY `addressBookId` (`addressBookId`),
  CONSTRAINT `addressbook_group_ibfk_1` FOREIGN KEY (`addressBookId`) REFERENCES `addressbook_addressbook` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `addressbook_group`
--

LOCK TABLES `addressbook_group` WRITE;
/*!40000 ALTER TABLE `addressbook_group` DISABLE KEYS */;
/*!40000 ALTER TABLE `addressbook_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `addressbook_phone_number`
--

DROP TABLE IF EXISTS `addressbook_phone_number`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `addressbook_phone_number` (
  `contactId` int(11) NOT NULL,
  `type` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `number` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  KEY `contactId` (`contactId`),
  CONSTRAINT `addressbook_phone_number_ibfk_1` FOREIGN KEY (`contactId`) REFERENCES `addressbook_contact` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `addressbook_phone_number`
--

LOCK TABLES `addressbook_phone_number` WRITE;
/*!40000 ALTER TABLE `addressbook_phone_number` DISABLE KEYS */;
/*!40000 ALTER TABLE `addressbook_phone_number` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `addressbook_url`
--

DROP TABLE IF EXISTS `addressbook_url`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `addressbook_url` (
  `contactId` int(11) NOT NULL,
  `type` varchar(190) COLLATE utf8mb4_unicode_ci NOT NULL,
  `url` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  KEY `contactId` (`contactId`),
  CONSTRAINT `addressbook_url_ibfk_1` FOREIGN KEY (`contactId`) REFERENCES `addressbook_contact` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `addressbook_url`
--

LOCK TABLES `addressbook_url` WRITE;
/*!40000 ALTER TABLE `addressbook_url` DISABLE KEYS */;
/*!40000 ALTER TABLE `addressbook_url` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `addressbook_user_settings`
--

DROP TABLE IF EXISTS `addressbook_user_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `addressbook_user_settings` (
  `userId` int(11) NOT NULL,
  `defaultAddressBookId` int(11) DEFAULT NULL,
  PRIMARY KEY (`userId`),
  KEY `defaultAddressBookId` (`defaultAddressBookId`),
  CONSTRAINT `addressbook_user_settings_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `core_user` (`id`) ON DELETE CASCADE,
  CONSTRAINT `addressbook_user_settings_ibfk_2` FOREIGN KEY (`defaultAddressBookId`) REFERENCES `addressbook_addressbook` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `addressbook_user_settings`
--

LOCK TABLES `addressbook_user_settings` WRITE;
/*!40000 ALTER TABLE `addressbook_user_settings` DISABLE KEYS */;
INSERT INTO `addressbook_user_settings` VALUES (1,1);
/*!40000 ALTER TABLE `addressbook_user_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bookmarks_bookmark`
--

DROP TABLE IF EXISTS `bookmarks_bookmark`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `bookmarks_bookmark` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `categoryId` int(11) NOT NULL,
  `createdBy` int(11) DEFAULT NULL,
  `name` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `content` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `logo` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `openExtern` tinyint(1) NOT NULL DEFAULT 1,
  `behaveAsModule` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `createdBy` (`createdBy`),
  KEY `categoryId` (`categoryId`),
  CONSTRAINT `bookmarks_bookmark_ibfk_1` FOREIGN KEY (`createdBy`) REFERENCES `core_user` (`id`) ON DELETE SET NULL,
  CONSTRAINT `bookmarks_bookmark_ibfk_2` FOREIGN KEY (`categoryId`) REFERENCES `bookmarks_category` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bookmarks_bookmark`
--

LOCK TABLES `bookmarks_bookmark` WRITE;
/*!40000 ALTER TABLE `bookmarks_bookmark` DISABLE KEYS */;
/*!40000 ALTER TABLE `bookmarks_bookmark` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bookmarks_category`
--

DROP TABLE IF EXISTS `bookmarks_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `bookmarks_category` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `createdBy` int(11) DEFAULT NULL,
  `aclId` int(11) NOT NULL,
  `name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `aclId` (`aclId`),
  KEY `createdBy` (`createdBy`),
  CONSTRAINT `bookmarks_category_acl_ibfk_1` FOREIGN KEY (`aclId`) REFERENCES `core_acl` (`id`),
  CONSTRAINT `bookmarks_category_ibfk_1` FOREIGN KEY (`createdBy`) REFERENCES `core_user` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bookmarks_category`
--

LOCK TABLES `bookmarks_category` WRITE;
/*!40000 ALTER TABLE `bookmarks_category` DISABLE KEYS */;
/*!40000 ALTER TABLE `bookmarks_category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cal_calendar_user_colors`
--

DROP TABLE IF EXISTS `cal_calendar_user_colors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cal_calendar_user_colors` (
  `user_id` int(11) NOT NULL,
  `calendar_id` int(11) NOT NULL,
  `color` varchar(6) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`user_id`,`calendar_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cal_calendar_user_colors`
--

LOCK TABLES `cal_calendar_user_colors` WRITE;
/*!40000 ALTER TABLE `cal_calendar_user_colors` DISABLE KEYS */;
/*!40000 ALTER TABLE `cal_calendar_user_colors` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cal_calendars`
--

DROP TABLE IF EXISTS `cal_calendars`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cal_calendars` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) NOT NULL DEFAULT 1,
  `user_id` int(11) NOT NULL DEFAULT 0,
  `acl_id` int(11) NOT NULL DEFAULT 0,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `start_hour` tinyint(4) NOT NULL DEFAULT 0,
  `end_hour` tinyint(4) NOT NULL DEFAULT 0,
  `background` varchar(6) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `time_interval` int(11) NOT NULL DEFAULT 1800,
  `public` tinyint(1) NOT NULL DEFAULT 0,
  `shared_acl` tinyint(1) NOT NULL DEFAULT 0,
  `show_bdays` tinyint(1) NOT NULL DEFAULT 0,
  `show_completed_tasks` tinyint(1) NOT NULL DEFAULT 1,
  `comment` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `project_id` int(11) NOT NULL DEFAULT 0,
  `tasklist_id` int(11) NOT NULL DEFAULT 0,
  `files_folder_id` int(11) NOT NULL DEFAULT 0,
  `show_holidays` tinyint(1) NOT NULL DEFAULT 1,
  `enable_ics_import` tinyint(1) NOT NULL DEFAULT 0,
  `ics_import_url` varchar(512) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `tooltip` varchar(127) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `version` int(10) unsigned NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  KEY `group_id` (`group_id`),
  KEY `project_id` (`project_id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cal_calendars`
--

LOCK TABLES `cal_calendars` WRITE;
/*!40000 ALTER TABLE `cal_calendars` DISABLE KEYS */;
INSERT INTO `cal_calendars` VALUES (1,1,1,38,'System Administrator',0,0,NULL,1800,0,0,0,1,'',0,0,2,1,0,'','',1);
/*!40000 ALTER TABLE `cal_calendars` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cal_calendars_custom_fields`
--

DROP TABLE IF EXISTS `cal_calendars_custom_fields`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cal_calendars_custom_fields` (
  `id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `cal_calendars_custom_fields_ibfk_1` FOREIGN KEY (`id`) REFERENCES `cal_calendars` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cal_calendars_custom_fields`
--

LOCK TABLES `cal_calendars_custom_fields` WRITE;
/*!40000 ALTER TABLE `cal_calendars_custom_fields` DISABLE KEYS */;
/*!40000 ALTER TABLE `cal_calendars_custom_fields` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cal_categories`
--

DROP TABLE IF EXISTS `cal_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cal_categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `color` char(6) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'EBF1E2',
  `calendar_id` int(11) NOT NULL,
  `acl_id` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `calendar_id` (`calendar_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cal_categories`
--

LOCK TABLES `cal_categories` WRITE;
/*!40000 ALTER TABLE `cal_categories` DISABLE KEYS */;
/*!40000 ALTER TABLE `cal_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cal_events`
--

DROP TABLE IF EXISTS `cal_events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cal_events` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uuid` varchar(190) CHARACTER SET ascii COLLATE ascii_bin NOT NULL DEFAULT '',
  `calendar_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL DEFAULT 0,
  `start_time` int(11) NOT NULL DEFAULT 0,
  `end_time` int(11) NOT NULL DEFAULT 0,
  `timezone` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `all_day_event` tinyint(1) NOT NULL DEFAULT 0,
  `name` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `location` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `repeat_end_time` int(11) NOT NULL DEFAULT 0,
  `reminder` int(11) DEFAULT NULL,
  `ctime` int(11) NOT NULL DEFAULT 0,
  `mtime` int(11) NOT NULL DEFAULT 0,
  `muser_id` int(11) NOT NULL DEFAULT 0,
  `busy` tinyint(1) NOT NULL DEFAULT 1,
  `status` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'NEEDS-ACTION',
  `resource_event_id` int(11) NOT NULL DEFAULT 0,
  `private` tinyint(1) NOT NULL DEFAULT 0,
  `rrule` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `background` char(6) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'ebf1e2',
  `files_folder_id` int(11) NOT NULL,
  `read_only` tinyint(1) NOT NULL DEFAULT 0,
  `category_id` int(11) DEFAULT NULL,
  `exception_for_event_id` int(11) NOT NULL DEFAULT 0,
  `recurrence_id` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `is_organizer` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  KEY `start_time` (`start_time`),
  KEY `end_time` (`end_time`),
  KEY `repeat_end_time` (`repeat_end_time`),
  KEY `rrule` (`rrule`),
  KEY `calendar_id` (`calendar_id`),
  KEY `busy` (`busy`),
  KEY `category_id` (`category_id`),
  KEY `uuid` (`uuid`),
  KEY `resource_event_id` (`resource_event_id`),
  KEY `recurrence_id` (`recurrence_id`),
  KEY `exception_for_event_id` (`exception_for_event_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cal_events`
--

LOCK TABLES `cal_events` WRITE;
/*!40000 ALTER TABLE `cal_events` DISABLE KEYS */;
/*!40000 ALTER TABLE `cal_events` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cal_events_custom_fields`
--

DROP TABLE IF EXISTS `cal_events_custom_fields`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cal_events_custom_fields` (
  `id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `cal_events_custom_fields_ibfk_1` FOREIGN KEY (`id`) REFERENCES `cal_events` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cal_events_custom_fields`
--

LOCK TABLES `cal_events_custom_fields` WRITE;
/*!40000 ALTER TABLE `cal_events_custom_fields` DISABLE KEYS */;
/*!40000 ALTER TABLE `cal_events_custom_fields` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cal_events_declined`
--

DROP TABLE IF EXISTS `cal_events_declined`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cal_events_declined` (
  `uid` varchar(190) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`uid`,`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cal_events_declined`
--

LOCK TABLES `cal_events_declined` WRITE;
/*!40000 ALTER TABLE `cal_events_declined` DISABLE KEYS */;
/*!40000 ALTER TABLE `cal_events_declined` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cal_exceptions`
--

DROP TABLE IF EXISTS `cal_exceptions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cal_exceptions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `event_id` int(11) NOT NULL DEFAULT 0,
  `time` int(11) NOT NULL DEFAULT 0,
  `exception_event_id` int(11) NOT NULL DEFAULT 0,
  `user_id` int(11) NOT NULL DEFAULT 0,
  `muser_id` int(11) NOT NULL DEFAULT 0,
  `ctime` int(11) NOT NULL DEFAULT 0,
  `mtime` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `event_id` (`event_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cal_exceptions`
--

LOCK TABLES `cal_exceptions` WRITE;
/*!40000 ALTER TABLE `cal_exceptions` DISABLE KEYS */;
/*!40000 ALTER TABLE `cal_exceptions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cal_group_admins`
--

DROP TABLE IF EXISTS `cal_group_admins`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cal_group_admins` (
  `group_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`group_id`,`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cal_group_admins`
--

LOCK TABLES `cal_group_admins` WRITE;
/*!40000 ALTER TABLE `cal_group_admins` DISABLE KEYS */;
/*!40000 ALTER TABLE `cal_group_admins` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cal_groups`
--

DROP TABLE IF EXISTS `cal_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cal_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT 0,
  `name` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fields` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `show_not_as_busy` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cal_groups`
--

LOCK TABLES `cal_groups` WRITE;
/*!40000 ALTER TABLE `cal_groups` DISABLE KEYS */;
INSERT INTO `cal_groups` VALUES (1,1,'Calendars','',0);
/*!40000 ALTER TABLE `cal_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cal_participants`
--

DROP TABLE IF EXISTS `cal_participants`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cal_participants` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `event_id` int(11) NOT NULL,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_id` int(11) NOT NULL DEFAULT 0,
  `contact_id` int(11) NOT NULL DEFAULT 0,
  `status` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'NEEDS-ACTION',
  `last_modified` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `is_organizer` tinyint(1) NOT NULL DEFAULT 0,
  `role` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `event_id` (`event_id`,`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cal_participants`
--

LOCK TABLES `cal_participants` WRITE;
/*!40000 ALTER TABLE `cal_participants` DISABLE KEYS */;
/*!40000 ALTER TABLE `cal_participants` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cal_settings`
--

DROP TABLE IF EXISTS `cal_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cal_settings` (
  `user_id` int(11) NOT NULL,
  `reminder` int(11) DEFAULT NULL,
  `background` char(6) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'EBF1E2',
  `calendar_id` int(11) NOT NULL DEFAULT 0,
  `show_statuses` tinyint(1) NOT NULL DEFAULT 1,
  `check_conflict` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`user_id`),
  KEY `calendar_id` (`calendar_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cal_settings`
--

LOCK TABLES `cal_settings` WRITE;
/*!40000 ALTER TABLE `cal_settings` DISABLE KEYS */;
INSERT INTO `cal_settings` VALUES (1,NULL,'EBF1E2',1,1,1);
/*!40000 ALTER TABLE `cal_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cal_views`
--

DROP TABLE IF EXISTS `cal_views`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cal_views` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT 0,
  `name` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `time_interval` int(11) NOT NULL DEFAULT 1800,
  `acl_id` int(11) NOT NULL DEFAULT 0,
  `merge` tinyint(1) NOT NULL DEFAULT 0,
  `owncolor` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cal_views`
--

LOCK TABLES `cal_views` WRITE;
/*!40000 ALTER TABLE `cal_views` DISABLE KEYS */;
/*!40000 ALTER TABLE `cal_views` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cal_views_calendars`
--

DROP TABLE IF EXISTS `cal_views_calendars`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cal_views_calendars` (
  `view_id` int(11) NOT NULL DEFAULT 0,
  `calendar_id` int(11) NOT NULL DEFAULT 0,
  `background` char(6) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'CCFFCC',
  PRIMARY KEY (`view_id`,`calendar_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cal_views_calendars`
--

LOCK TABLES `cal_views_calendars` WRITE;
/*!40000 ALTER TABLE `cal_views_calendars` DISABLE KEYS */;
/*!40000 ALTER TABLE `cal_views_calendars` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cal_views_groups`
--

DROP TABLE IF EXISTS `cal_views_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cal_views_groups` (
  `view_id` int(11) NOT NULL,
  `group_id` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`view_id`,`group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cal_views_groups`
--

LOCK TABLES `cal_views_groups` WRITE;
/*!40000 ALTER TABLE `cal_views_groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `cal_views_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cal_visible_tasklists`
--

DROP TABLE IF EXISTS `cal_visible_tasklists`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cal_visible_tasklists` (
  `calendar_id` int(11) NOT NULL,
  `tasklist_id` int(11) NOT NULL,
  PRIMARY KEY (`calendar_id`,`tasklist_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cal_visible_tasklists`
--

LOCK TABLES `cal_visible_tasklists` WRITE;
/*!40000 ALTER TABLE `cal_visible_tasklists` DISABLE KEYS */;
/*!40000 ALTER TABLE `cal_visible_tasklists` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comments_attachment`
--

DROP TABLE IF EXISTS `comments_attachment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `comments_attachment` (
  `commentId` int(11) NOT NULL,
  `blobId` binary(40) NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`commentId`,`blobId`),
  KEY `fk_comments_attachment_comments_comment1_idx` (`commentId`),
  KEY `fk_comments_attachment_core_blob1_idx` (`blobId`),
  CONSTRAINT `fk_comments_attachment_comments_comment1` FOREIGN KEY (`commentId`) REFERENCES `comments_comment` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `fk_comments_attachment_core_blob1` FOREIGN KEY (`blobId`) REFERENCES `core_blob` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comments_attachment`
--

LOCK TABLES `comments_attachment` WRITE;
/*!40000 ALTER TABLE `comments_attachment` DISABLE KEYS */;
/*!40000 ALTER TABLE `comments_attachment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comments_comment`
--

DROP TABLE IF EXISTS `comments_comment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `comments_comment` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `createdAt` datetime NOT NULL,
  `entityId` int(11) NOT NULL,
  `entityTypeId` int(11) NOT NULL,
  `createdBy` int(11) DEFAULT NULL,
  `modifiedBy` int(11) DEFAULT NULL,
  `modifiedAt` datetime DEFAULT NULL,
  `text` mediumtext COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `section` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_comments_comment_core_entity_type_idx` (`entityId`),
  KEY `fk_comments_comment_core_user1_idx` (`createdBy`),
  KEY `fk_comments_comment_core_user2_idx` (`modifiedBy`),
  KEY `entityTypeId` (`entityTypeId`),
  KEY `section` (`section`),
  CONSTRAINT `comments_comment_ibfk_1` FOREIGN KEY (`entityTypeId`) REFERENCES `core_entity` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `fk_comments_comment_core_user1` FOREIGN KEY (`createdBy`) REFERENCES `core_user` (`id`) ON DELETE SET NULL ON UPDATE NO ACTION,
  CONSTRAINT `fk_comments_comment_core_user2` FOREIGN KEY (`modifiedBy`) REFERENCES `core_user` (`id`) ON DELETE SET NULL ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comments_comment`
--

LOCK TABLES `comments_comment` WRITE;
/*!40000 ALTER TABLE `comments_comment` DISABLE KEYS */;
/*!40000 ALTER TABLE `comments_comment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comments_comment_image`
--

DROP TABLE IF EXISTS `comments_comment_image`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `comments_comment_image` (
  `commentId` int(11) NOT NULL,
  `blobId` binary(40) NOT NULL,
  PRIMARY KEY (`commentId`,`blobId`),
  KEY `blobId` (`blobId`),
  CONSTRAINT `comments_comment_image_ibfk_1` FOREIGN KEY (`blobId`) REFERENCES `core_blob` (`id`),
  CONSTRAINT `comments_comment_image_ibfk_2` FOREIGN KEY (`commentId`) REFERENCES `comments_comment` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comments_comment_image`
--

LOCK TABLES `comments_comment_image` WRITE;
/*!40000 ALTER TABLE `comments_comment_image` DISABLE KEYS */;
/*!40000 ALTER TABLE `comments_comment_image` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comments_comment_label`
--

DROP TABLE IF EXISTS `comments_comment_label`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `comments_comment_label` (
  `labelId` int(11) NOT NULL,
  `commentId` int(11) NOT NULL,
  PRIMARY KEY (`labelId`,`commentId`),
  KEY `fk_comments_label_has_comments_comment_comments_comment1_idx` (`commentId`),
  KEY `fk_comments_label_has_comments_comment_comments_label1_idx` (`labelId`),
  CONSTRAINT `fk_comments_label_has_comments_comment_comments_comment1` FOREIGN KEY (`commentId`) REFERENCES `comments_comment` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `fk_comments_label_has_comments_comment_comments_label1` FOREIGN KEY (`labelId`) REFERENCES `comments_label` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comments_comment_label`
--

LOCK TABLES `comments_comment_label` WRITE;
/*!40000 ALTER TABLE `comments_comment_label` DISABLE KEYS */;
/*!40000 ALTER TABLE `comments_comment_label` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comments_label`
--

DROP TABLE IF EXISTS `comments_label`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `comments_label` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(127) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `color` char(6) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '243a80',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comments_label`
--

LOCK TABLES `comments_label` WRITE;
/*!40000 ALTER TABLE `comments_label` DISABLE KEYS */;
/*!40000 ALTER TABLE `comments_label` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_acl`
--

DROP TABLE IF EXISTS `core_acl`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `core_acl` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ownedBy` int(11) NOT NULL,
  `usedIn` varchar(190) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `modifiedAt` datetime DEFAULT NULL,
  `entityTypeId` int(11) DEFAULT NULL,
  `entityId` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `core_acl_ibfk_1` (`entityTypeId`),
  CONSTRAINT `core_acl_ibfk_1` FOREIGN KEY (`entityTypeId`) REFERENCES `core_entity` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=52 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_acl`
--

LOCK TABLES `core_acl` WRITE;
/*!40000 ALTER TABLE `core_acl` DISABLE KEYS */;
INSERT INTO `core_acl` VALUES (1,1,'core_group.aclId','2020-07-25 10:50:42',1,1),(2,1,'core_group.aclId','2020-07-25 10:50:42',1,2),(3,1,'core_group.aclId','2020-07-25 10:50:43',1,3),(4,1,'core_group.aclId','2020-07-25 10:50:43',1,4),(5,1,'core_module.aclId','2020-07-25 10:50:43',13,1),(6,1,'core_entity.defaultAclId','2020-07-25 10:50:43',NULL,NULL),(7,1,'core_entity.defaultAclId','2020-07-25 10:50:43',NULL,NULL),(8,1,'go_templates.acl_id','2020-07-25 10:50:43',20,1),(9,1,'core_module.aclId','2020-07-25 10:50:44',13,2),(10,1,'addressbook_addressbook.aclId','2020-07-25 10:50:44',21,1),(11,1,'core_module.aclId','2020-07-25 10:50:44',13,3),(12,1,'notes_note_book.aclId','2020-07-25 10:50:44',25,65),(13,1,'core_module.aclId','2020-07-25 10:50:44',13,4),(14,1,'core_module.aclId','2020-07-25 10:50:45',13,5),(15,1,'core_module.aclId','2020-07-25 10:50:45',13,6),(16,1,'core_module.aclId','2020-07-25 10:50:45',13,7),(17,1,'core_entity.defaultAclId','2020-07-25 10:50:46',NULL,NULL),(18,1,'core_module.aclId','2020-07-25 10:50:46',13,8),(20,1,'core_module.aclId','2020-07-25 10:50:46',13,10),(21,1,'core_module.aclId','2020-07-25 10:50:46',13,11),(22,1,'fs_templates.acl_id','2020-07-25 10:50:46',20,1),(23,1,'fs_templates.acl_id','2020-07-25 10:50:46',20,2),(24,1,'core_module.aclId','2020-07-25 10:50:47',13,12),(25,1,'core_module.aclId','2020-07-25 10:50:47',13,13),(26,1,'core_module.aclId','2020-07-25 10:50:47',13,14),(27,1,'core_module.aclId','2020-07-25 10:50:47',13,15),(28,1,'core_module.aclId','2020-07-25 10:50:47',13,16),(29,1,'core_entity.defaultAclId','2020-07-25 11:09:13',NULL,NULL),(30,1,'addressbook_addressbook.aclId','2020-07-25 11:09:13',21,2),(31,1,'core_entity.defaultAclId','2020-07-25 11:09:13',NULL,NULL),(32,1,'core_entity.defaultAclId','2020-07-25 11:09:13',NULL,NULL),(33,1,'core_entity.defaultAclId','2020-07-25 11:09:13',NULL,NULL),(34,1,'core_entity.defaultAclId','2020-07-25 11:09:13',NULL,NULL),(35,1,'core_entity.defaultAclId','2020-07-25 11:09:13',NULL,NULL),(36,1,'core_entity.defaultAclId','2020-07-25 11:09:13',NULL,NULL),(37,1,'core_entity.defaultAclId','2020-07-25 11:09:13',NULL,NULL),(38,1,'cal_calendars.acl_id','2020-07-25 11:09:14',30,1),(39,1,'fs_folders.acl_id','2020-07-25 11:09:20',33,4),(40,1,'core_module.aclId','2020-07-25 11:12:26',13,17),(41,1,'core_module.aclId','2020-07-25 11:12:26',13,18),(42,1,'core_module.aclId','2020-07-25 11:12:32',13,19),(43,1,'core_module.aclId','2020-07-25 11:12:35',13,20),(44,1,'core_module.aclId','2020-07-25 11:12:39',13,21),(45,1,'core_module.aclId','2020-07-25 11:12:54',13,22),(46,1,'core_module.aclId','2020-07-25 11:12:58',13,23),(47,1,'core_module.aclId','2020-07-25 11:13:10',13,24),(48,1,'core_module.aclId','2020-07-25 11:13:15',13,25),(49,1,'core_module.aclId','2020-07-25 11:13:24',13,26),(50,1,'fs_folders.acl_id','2020-07-25 11:14:12',NULL,NULL),(51,1,'fs_folders.acl_id','2020-07-25 11:14:12',33,5);
/*!40000 ALTER TABLE `core_acl` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_acl_group`
--

DROP TABLE IF EXISTS `core_acl_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `core_acl_group` (
  `aclId` int(11) NOT NULL,
  `groupId` int(11) NOT NULL DEFAULT 0,
  `level` tinyint(4) NOT NULL DEFAULT 10,
  PRIMARY KEY (`aclId`,`groupId`),
  KEY `level` (`level`),
  KEY `groupId` (`groupId`),
  CONSTRAINT `core_acl_group_ibfk_1` FOREIGN KEY (`groupId`) REFERENCES `core_group` (`id`) ON DELETE CASCADE,
  CONSTRAINT `core_acl_group_ibfk_2` FOREIGN KEY (`aclId`) REFERENCES `core_acl` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_acl_group`
--

LOCK TABLES `core_acl_group` WRITE;
/*!40000 ALTER TABLE `core_acl_group` DISABLE KEYS */;
INSERT INTO `core_acl_group` VALUES (2,2,10),(3,3,10),(4,4,10),(5,2,10),(6,2,10),(7,2,10),(8,3,10),(9,3,10),(11,3,10),(13,3,10),(14,3,10),(15,3,10),(16,3,10),(20,3,10),(21,3,10),(22,3,10),(23,3,10),(24,3,10),(25,3,10),(26,3,10),(27,3,10),(30,3,10),(40,3,10),(41,3,10),(42,3,10),(45,3,10),(47,3,10),(48,3,10),(49,3,10),(50,2,10),(17,3,30),(10,3,40),(12,3,40),(1,1,50),(2,1,50),(3,1,50),(4,1,50),(5,1,50),(6,1,50),(7,1,50),(8,1,50),(9,1,50),(10,1,50),(11,1,50),(12,1,50),(13,1,50),(14,1,50),(15,1,50),(16,1,50),(17,1,50),(18,1,50),(20,1,50),(21,1,50),(22,1,50),(23,1,50),(24,1,50),(25,1,50),(26,1,50),(27,1,50),(28,1,50),(29,1,50),(30,1,50),(31,1,50),(32,1,50),(33,1,50),(34,1,50),(35,1,50),(36,1,50),(37,1,50),(38,1,50),(39,1,50),(40,1,50),(41,1,50),(42,1,50),(43,1,50),(44,1,50),(45,1,50),(46,1,50),(47,1,50),(48,1,50),(49,1,50),(50,1,50),(51,1,50);
/*!40000 ALTER TABLE `core_acl_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_acl_group_changes`
--

DROP TABLE IF EXISTS `core_acl_group_changes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `core_acl_group_changes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `aclId` int(11) NOT NULL,
  `groupId` int(11) NOT NULL,
  `grantModSeq` int(11) NOT NULL,
  `revokeModSeq` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `aclId` (`aclId`,`groupId`),
  KEY `group` (`groupId`),
  CONSTRAINT `all` FOREIGN KEY (`aclId`) REFERENCES `core_acl` (`id`) ON DELETE CASCADE,
  CONSTRAINT `group` FOREIGN KEY (`groupId`) REFERENCES `core_group` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=59 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_acl_group_changes`
--

LOCK TABLES `core_acl_group_changes` WRITE;
/*!40000 ALTER TABLE `core_acl_group_changes` DISABLE KEYS */;
INSERT INTO `core_acl_group_changes` VALUES (1,8,1,1,NULL),(2,8,3,1,NULL),(3,16,1,2,NULL),(4,16,3,2,NULL),(5,17,1,2,NULL),(6,17,3,2,NULL),(7,18,1,2,NULL),(10,20,1,2,NULL),(11,20,3,2,NULL),(12,21,1,2,NULL),(13,21,3,2,NULL),(14,22,1,2,NULL),(15,22,3,2,NULL),(16,23,1,2,NULL),(17,23,3,2,NULL),(18,24,1,2,NULL),(19,24,3,2,NULL),(20,25,1,2,NULL),(21,25,3,2,NULL),(22,26,1,2,NULL),(23,26,3,2,NULL),(24,27,1,2,NULL),(25,27,3,2,NULL),(26,28,1,2,NULL),(27,29,1,3,NULL),(28,30,1,3,NULL),(29,30,3,3,NULL),(30,31,1,4,NULL),(31,32,1,4,NULL),(32,33,1,4,NULL),(33,34,1,4,NULL),(34,35,1,4,NULL),(35,36,1,4,NULL),(36,37,1,4,NULL),(37,38,1,5,NULL),(38,39,1,7,NULL),(39,40,1,8,NULL),(40,40,3,8,NULL),(41,41,1,8,NULL),(42,41,3,8,NULL),(43,42,1,9,NULL),(44,42,3,9,NULL),(45,43,1,10,NULL),(46,44,1,11,NULL),(47,45,1,12,NULL),(48,45,3,12,NULL),(49,46,1,13,NULL),(50,47,1,14,NULL),(51,47,3,14,NULL),(52,48,1,15,NULL),(53,48,3,15,NULL),(54,49,1,16,NULL),(55,49,3,16,NULL),(56,50,2,17,NULL),(57,50,1,17,NULL),(58,51,1,17,NULL);
/*!40000 ALTER TABLE `core_acl_group_changes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_auth_allow_group`
--

DROP TABLE IF EXISTS `core_auth_allow_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `core_auth_allow_group` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `groupId` int(11) NOT NULL,
  `ipPattern` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'IP Address. Wildcards can be used where * matches anything and ? matches exactly one character',
  PRIMARY KEY (`id`),
  KEY `groupId` (`groupId`),
  CONSTRAINT `core_auth_allow_group_ibfk_1` FOREIGN KEY (`groupId`) REFERENCES `core_group` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_auth_allow_group`
--

LOCK TABLES `core_auth_allow_group` WRITE;
/*!40000 ALTER TABLE `core_auth_allow_group` DISABLE KEYS */;
/*!40000 ALTER TABLE `core_auth_allow_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_auth_method`
--

DROP TABLE IF EXISTS `core_auth_method`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `core_auth_method` (
  `id` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `moduleId` int(11) NOT NULL,
  `sortOrder` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `moduleId` (`moduleId`),
  KEY `moduleId_sortOrder` (`moduleId`,`sortOrder`),
  CONSTRAINT `core_auth_method_ibfk_1` FOREIGN KEY (`moduleId`) REFERENCES `core_module` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_auth_method`
--

LOCK TABLES `core_auth_method` WRITE;
/*!40000 ALTER TABLE `core_auth_method` DISABLE KEYS */;
INSERT INTO `core_auth_method` VALUES ('password',1,1),('googleauthenticator',4,2),('imap',23,3);
/*!40000 ALTER TABLE `core_auth_method` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_auth_password`
--

DROP TABLE IF EXISTS `core_auth_password`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `core_auth_password` (
  `userId` int(11) NOT NULL,
  `password` varchar(190) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`userId`),
  CONSTRAINT `core_auth_password_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `core_user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_auth_password`
--

LOCK TABLES `core_auth_password` WRITE;
/*!40000 ALTER TABLE `core_auth_password` DISABLE KEYS */;
INSERT INTO `core_auth_password` VALUES (1,'$2y$10$8eZyIjI7rcMJ.RDUXqg5weU0mj6tWTGGn3C9vveGrBkGlL/VLH8ta');
/*!40000 ALTER TABLE `core_auth_password` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_auth_token`
--

DROP TABLE IF EXISTS `core_auth_token`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `core_auth_token` (
  `loginToken` varchar(100) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `accessToken` varchar(100) CHARACTER SET ascii COLLATE ascii_bin DEFAULT NULL,
  `userId` int(11) NOT NULL,
  `createdAt` datetime NOT NULL,
  `expiresAt` datetime DEFAULT NULL,
  `lastActiveAt` datetime NOT NULL,
  `remoteIpAddress` varchar(100) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `userAgent` varchar(190) COLLATE utf8mb4_unicode_ci NOT NULL,
  `passedMethods` varchar(190) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`loginToken`),
  KEY `userId` (`userId`),
  KEY `accessToken` (`accessToken`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_auth_token`
--

LOCK TABLES `core_auth_token` WRITE;
/*!40000 ALTER TABLE `core_auth_token` DISABLE KEYS */;
INSERT INTO `core_auth_token` VALUES ('5f1c12d8e3edf70a73fca60f7fb1d3394077e48bd763d','5f1c12d90bdb6f0e9cbb5cd3c91dbdeeeccfa693e3c80',1,'2020-07-25 11:09:12','2020-08-01 11:09:13','2020-07-25 11:09:12','43.242.229.111','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/84.0.4147.89 Safari/537.36','password');
/*!40000 ALTER TABLE `core_auth_token` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_blob`
--

DROP TABLE IF EXISTS `core_blob`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `core_blob` (
  `id` binary(40) NOT NULL,
  `type` varchar(129) COLLATE utf8mb4_unicode_ci NOT NULL,
  `size` bigint(20) NOT NULL DEFAULT 0,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `createdAt` datetime NOT NULL,
  `modifiedAt` datetime DEFAULT NULL,
  `staleAt` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `staleAt` (`staleAt`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_blob`
--

LOCK TABLES `core_blob` WRITE;
/*!40000 ALTER TABLE `core_blob` DISABLE KEYS */;
/*!40000 ALTER TABLE `core_blob` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_change`
--

DROP TABLE IF EXISTS `core_change`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `core_change` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entityId` int(11) NOT NULL,
  `entityTypeId` int(11) NOT NULL,
  `modSeq` int(11) NOT NULL,
  `aclId` int(11) DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `destroyed` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `aclId` (`aclId`),
  KEY `entityTypeId` (`entityTypeId`),
  KEY `entityId` (`entityId`),
  CONSTRAINT `core_change_ibfk_1` FOREIGN KEY (`entityTypeId`) REFERENCES `core_entity` (`id`) ON DELETE CASCADE,
  CONSTRAINT `core_change_ibfk_2` FOREIGN KEY (`aclId`) REFERENCES `core_acl` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_change`
--

LOCK TABLES `core_change` WRITE;
/*!40000 ALTER TABLE `core_change` DISABLE KEYS */;
INSERT INTO `core_change` VALUES (1,1,19,1,5,'2020-07-25 11:09:13',0),(2,2,21,1,30,'2020-07-25 11:09:13',0),(3,1,19,2,5,'2020-07-25 11:09:13',0),(4,1,16,1,38,'2020-07-25 11:09:14',0),(5,2,16,1,38,'2020-07-25 11:09:14',0),(6,3,16,2,21,'2020-07-25 13:09:20',0),(7,4,16,2,21,'2020-07-25 13:09:20',0),(8,4,16,2,39,'2020-07-25 13:09:20',0),(9,5,16,2,21,'2020-07-25 13:09:20',0),(10,1,13,1,5,'2020-07-25 11:11:47',0),(11,20,13,2,43,'2020-07-25 11:12:35',0),(12,23,13,3,46,'2020-07-25 11:12:58',0),(13,6,16,3,50,'2020-07-25 13:14:27',0),(14,1,16,4,38,'2020-07-25 13:14:33',0),(15,2,16,4,38,'2020-07-25 13:14:33',0),(16,3,16,4,21,'2020-07-25 13:14:33',0),(17,4,16,4,39,'2020-07-25 13:14:33',0),(18,5,16,4,51,'2020-07-25 13:14:33',0),(19,6,16,4,50,'2020-07-25 13:14:33',0),(20,7,16,5,21,'2020-07-25 13:14:44',0),(21,8,16,5,21,'2020-07-25 13:14:44',0),(22,9,16,5,21,'2020-07-25 13:14:44',0),(23,1,13,4,5,'2020-07-25 11:15:47',0),(24,10,16,6,21,'2020-07-25 11:15:51',0),(25,11,16,6,21,'2020-07-25 11:15:51',0),(26,1,13,5,5,'2020-07-25 11:16:57',0),(27,3,35,1,46,'2020-07-25 11:18:54',0);
/*!40000 ALTER TABLE `core_change` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_change_user`
--

DROP TABLE IF EXISTS `core_change_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `core_change_user` (
  `userId` int(11) NOT NULL,
  `entityId` int(11) NOT NULL,
  `entityTypeId` int(11) NOT NULL,
  `modSeq` int(11) NOT NULL,
  PRIMARY KEY (`userId`,`entityId`,`entityTypeId`),
  KEY `entityTypeId` (`entityTypeId`),
  CONSTRAINT `core_change_user_ibfk_1` FOREIGN KEY (`entityTypeId`) REFERENCES `core_entity` (`id`) ON DELETE CASCADE,
  CONSTRAINT `core_change_user_ibfk_2` FOREIGN KEY (`userId`) REFERENCES `core_user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_change_user`
--

LOCK TABLES `core_change_user` WRITE;
/*!40000 ALTER TABLE `core_change_user` DISABLE KEYS */;
/*!40000 ALTER TABLE `core_change_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_change_user_modseq`
--

DROP TABLE IF EXISTS `core_change_user_modseq`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `core_change_user_modseq` (
  `userId` int(11) NOT NULL,
  `entityTypeId` int(11) NOT NULL,
  `highestModSeq` int(11) NOT NULL DEFAULT 0,
  `lowestModSeq` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`userId`,`entityTypeId`),
  KEY `entityTypeId` (`entityTypeId`),
  CONSTRAINT `core_change_user_modseq_ibfk_1` FOREIGN KEY (`entityTypeId`) REFERENCES `core_entity` (`id`) ON DELETE CASCADE,
  CONSTRAINT `core_change_user_modseq_ibfk_2` FOREIGN KEY (`userId`) REFERENCES `core_user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_change_user_modseq`
--

LOCK TABLES `core_change_user_modseq` WRITE;
/*!40000 ALTER TABLE `core_change_user_modseq` DISABLE KEYS */;
/*!40000 ALTER TABLE `core_change_user_modseq` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_cron_job`
--

DROP TABLE IF EXISTS `core_cron_job`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `core_cron_job` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `moduleId` int(11) NOT NULL,
  `description` varchar(190) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(190) COLLATE utf8mb4_unicode_ci NOT NULL,
  `expression` varchar(190) COLLATE utf8mb4_unicode_ci NOT NULL,
  `enabled` tinyint(1) NOT NULL DEFAULT 1,
  `nextRunAt` datetime DEFAULT NULL,
  `lastRunAt` datetime DEFAULT NULL,
  `runningSince` datetime DEFAULT NULL,
  `lastError` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `description` (`description`),
  KEY `moduleId` (`moduleId`),
  CONSTRAINT `core_cron_job_ibfk_1` FOREIGN KEY (`moduleId`) REFERENCES `core_module` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_cron_job`
--

LOCK TABLES `core_cron_job` WRITE;
/*!40000 ALTER TABLE `core_cron_job` DISABLE KEYS */;
INSERT INTO `core_cron_job` VALUES (1,1,'Garbage collection','GarbageCollection','0 * * * *',1,'2020-07-25 11:00:00',NULL,NULL,NULL);
/*!40000 ALTER TABLE `core_cron_job` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_customfields_field`
--

DROP TABLE IF EXISTS `core_customfields_field`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `core_customfields_field` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `fieldSetId` int(11) NOT NULL,
  `modSeq` int(11) DEFAULT NULL,
  `createdAt` datetime DEFAULT NULL,
  `modifiedAt` datetime DEFAULT NULL,
  `deletedAt` datetime DEFAULT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `databaseName` varchar(190) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `type` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Text',
  `sortOrder` int(11) NOT NULL DEFAULT 0,
  `required` tinyint(1) NOT NULL DEFAULT 0,
  `relatedFieldCondition` varchar(190) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `conditionallyHidden` tinyint(1) NOT NULL DEFAULT 0,
  `conditionallyRequired` tinyint(1) NOT NULL DEFAULT 0,
  `hint` varchar(190) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `exclude_from_grid` tinyint(1) NOT NULL DEFAULT 0,
  `unique_values` tinyint(1) NOT NULL DEFAULT 0,
  `prefix` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `suffix` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `options` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `hiddenInGrid` tinyint(1) NOT NULL DEFAULT 1,
  `filterable` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `type` (`fieldSetId`),
  KEY `modSeq` (`modSeq`),
  CONSTRAINT `core_customfields_field_ibfk_1` FOREIGN KEY (`fieldSetId`) REFERENCES `core_customfields_field_set` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_customfields_field`
--

LOCK TABLES `core_customfields_field` WRITE;
/*!40000 ALTER TABLE `core_customfields_field` DISABLE KEYS */;
/*!40000 ALTER TABLE `core_customfields_field` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_customfields_field_set`
--

DROP TABLE IF EXISTS `core_customfields_field_set`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `core_customfields_field_set` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `modSeq` int(11) DEFAULT NULL,
  `createdAt` datetime DEFAULT NULL,
  `modifiedAt` datetime DEFAULT NULL,
  `deletedAt` datetime DEFAULT NULL,
  `entityId` int(11) NOT NULL,
  `aclId` int(11) NOT NULL,
  `name` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sortOrder` tinyint(4) NOT NULL DEFAULT 0,
  `filter` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `isTab` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `entityId` (`entityId`),
  KEY `aclId` (`aclId`),
  KEY `modSeq` (`modSeq`),
  CONSTRAINT `core_customfields_field_set_ibfk_1` FOREIGN KEY (`entityId`) REFERENCES `core_entity` (`id`) ON DELETE CASCADE,
  CONSTRAINT `core_customfields_field_set_ibfk_2` FOREIGN KEY (`aclId`) REFERENCES `core_acl` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_customfields_field_set`
--

LOCK TABLES `core_customfields_field_set` WRITE;
/*!40000 ALTER TABLE `core_customfields_field_set` DISABLE KEYS */;
/*!40000 ALTER TABLE `core_customfields_field_set` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_customfields_select_option`
--

DROP TABLE IF EXISTS `core_customfields_select_option`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `core_customfields_select_option` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `fieldId` int(11) NOT NULL,
  `parentId` int(11) DEFAULT NULL,
  `text` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `field_id` (`fieldId`),
  KEY `parentId` (`parentId`),
  CONSTRAINT `core_customfields_select_option_ibfk_1` FOREIGN KEY (`fieldId`) REFERENCES `core_customfields_field` (`id`) ON DELETE CASCADE,
  CONSTRAINT `core_customfields_select_option_ibfk_2` FOREIGN KEY (`fieldId`) REFERENCES `core_customfields_field` (`id`) ON DELETE CASCADE,
  CONSTRAINT `core_customfields_select_option_ibfk_3` FOREIGN KEY (`parentId`) REFERENCES `core_customfields_select_option` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_customfields_select_option`
--

LOCK TABLES `core_customfields_select_option` WRITE;
/*!40000 ALTER TABLE `core_customfields_select_option` DISABLE KEYS */;
/*!40000 ALTER TABLE `core_customfields_select_option` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_email_template`
--

DROP TABLE IF EXISTS `core_email_template`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `core_email_template` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `moduleId` int(11) NOT NULL,
  `aclId` int(11) NOT NULL,
  `name` varchar(190) COLLATE utf8mb4_unicode_ci NOT NULL,
  `subject` varchar(190) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `body` mediumtext COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  KEY `aclId` (`aclId`),
  KEY `moduleId` (`moduleId`),
  CONSTRAINT `core_email_template_ibfk_1` FOREIGN KEY (`aclId`) REFERENCES `core_acl` (`id`),
  CONSTRAINT `core_email_template_ibfk_2` FOREIGN KEY (`moduleId`) REFERENCES `core_module` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_email_template`
--

LOCK TABLES `core_email_template` WRITE;
/*!40000 ALTER TABLE `core_email_template` DISABLE KEYS */;
/*!40000 ALTER TABLE `core_email_template` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_email_template_attachment`
--

DROP TABLE IF EXISTS `core_email_template_attachment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `core_email_template_attachment` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `emailTemplateId` int(11) NOT NULL,
  `blobId` binary(40) NOT NULL,
  `name` varchar(190) COLLATE utf8mb4_unicode_ci NOT NULL,
  `inline` tinyint(1) NOT NULL DEFAULT 0,
  `attachment` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `templateId` (`emailTemplateId`),
  KEY `blobId` (`blobId`),
  CONSTRAINT `core_email_template_attachment_ibfk_1` FOREIGN KEY (`blobId`) REFERENCES `core_blob` (`id`),
  CONSTRAINT `core_email_template_attachment_ibfk_2` FOREIGN KEY (`emailTemplateId`) REFERENCES `core_email_template` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_email_template_attachment`
--

LOCK TABLES `core_email_template_attachment` WRITE;
/*!40000 ALTER TABLE `core_email_template_attachment` DISABLE KEYS */;
/*!40000 ALTER TABLE `core_email_template_attachment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_entity`
--

DROP TABLE IF EXISTS `core_entity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `core_entity` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `moduleId` int(11) DEFAULT NULL,
  `name` varchar(190) COLLATE utf8mb4_unicode_ci NOT NULL,
  `clientName` varchar(190) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `highestModSeq` int(11) NOT NULL DEFAULT 0,
  `defaultAclId` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `clientName` (`clientName`),
  UNIQUE KEY `name` (`name`,`moduleId`) USING BTREE,
  KEY `moduleId` (`moduleId`),
  KEY `defaultAclId` (`defaultAclId`),
  CONSTRAINT `core_entity_ibfk_1` FOREIGN KEY (`moduleId`) REFERENCES `core_module` (`id`) ON DELETE CASCADE,
  CONSTRAINT `core_entity_ibfk_2` FOREIGN KEY (`defaultAclId`) REFERENCES `core_acl` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_entity`
--

LOCK TABLES `core_entity` WRITE;
/*!40000 ALTER TABLE `core_entity` DISABLE KEYS */;
INSERT INTO `core_entity` VALUES (1,1,'Group','Group',0,6),(2,1,'Method','Method',0,NULL),(3,1,'Blob','Blob',0,NULL),(4,1,'Acl','Acl',17,NULL),(5,1,'AuthAllowGroup','AuthAllowGroup',0,NULL),(6,1,'CronJobSchedule','CronJobSchedule',0,NULL),(7,1,'EmailTemplate','EmailTemplate',0,31),(8,1,'EntityFilter','EntityFilter',0,32),(9,1,'Field','Field',0,NULL),(10,1,'FieldSet','FieldSet',0,7),(11,1,'Link','Link',0,NULL),(12,1,'Log','Log',0,NULL),(13,1,'Module','Module',5,33),(14,1,'OauthAccessToken','OauthAccessToken',0,NULL),(15,1,'OauthClient','OauthClient',0,NULL),(16,1,'Search','Search',6,NULL),(17,1,'SmtpAccount','SmtpAccount',0,34),(18,1,'Token','Token',0,NULL),(19,1,'User','User',2,NULL),(20,1,'Template','Template',0,35),(21,2,'AddressBook','AddressBook',1,29),(22,2,'Contact','Contact',0,NULL),(23,2,'Group','AddressBookGroup',0,NULL),(24,3,'Note','Note',0,NULL),(25,3,'NoteBook','NoteBook',0,36),(26,5,'Comment','Comment',0,NULL),(27,5,'Label','CommentLabel',0,NULL),(28,6,'Bookmark','Bookmark',0,NULL),(29,6,'Category','BookmarksCategory',0,37),(30,7,'Calendar','Calendar',0,17),(31,7,'Event','Event',0,NULL),(32,11,'File','File',0,NULL),(33,11,'Folder','Folder',0,NULL),(34,15,'Task','Task',0,NULL),(35,23,'Server','ImapAuthServer',1,NULL);
/*!40000 ALTER TABLE `core_entity` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_entity_filter`
--

DROP TABLE IF EXISTS `core_entity_filter`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `core_entity_filter` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entityTypeId` int(11) NOT NULL,
  `name` varchar(190) COLLATE utf8mb4_unicode_ci NOT NULL,
  `createdBy` int(11) NOT NULL,
  `filter` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `aclId` int(11) NOT NULL,
  `type` enum('fixed','variable') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'fixed',
  PRIMARY KEY (`id`),
  KEY `aclid` (`aclId`),
  KEY `createdBy` (`createdBy`),
  KEY `entityTypeId` (`entityTypeId`),
  CONSTRAINT `core_entity_filter_ibfk_1` FOREIGN KEY (`aclId`) REFERENCES `core_acl` (`id`),
  CONSTRAINT `core_entity_filter_ibfk_2` FOREIGN KEY (`entityTypeId`) REFERENCES `core_entity` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_entity_filter`
--

LOCK TABLES `core_entity_filter` WRITE;
/*!40000 ALTER TABLE `core_entity_filter` DISABLE KEYS */;
/*!40000 ALTER TABLE `core_entity_filter` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_group`
--

DROP TABLE IF EXISTS `core_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `core_group` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(190) COLLATE utf8mb4_unicode_ci NOT NULL,
  `createdBy` int(11) NOT NULL,
  `aclId` int(11) DEFAULT NULL,
  `isUserGroupFor` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  KEY `isUserGroupFor` (`isUserGroupFor`),
  KEY `aclId` (`aclId`),
  CONSTRAINT `core_group_ibfk_1` FOREIGN KEY (`aclId`) REFERENCES `core_acl` (`id`),
  CONSTRAINT `core_group_ibfk_2` FOREIGN KEY (`isUserGroupFor`) REFERENCES `core_user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_group`
--

LOCK TABLES `core_group` WRITE;
/*!40000 ALTER TABLE `core_group` DISABLE KEYS */;
INSERT INTO `core_group` VALUES (1,'Admins',1,1,NULL),(2,'Everyone',1,2,NULL),(3,'Internal',1,3,NULL),(4,'groupofficeadmin',1,4,1);
/*!40000 ALTER TABLE `core_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_group_default_group`
--

DROP TABLE IF EXISTS `core_group_default_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `core_group_default_group` (
  `groupId` int(11) NOT NULL,
  PRIMARY KEY (`groupId`),
  CONSTRAINT `core_group_default_group_ibfk_1` FOREIGN KEY (`groupId`) REFERENCES `core_group` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_group_default_group`
--

LOCK TABLES `core_group_default_group` WRITE;
/*!40000 ALTER TABLE `core_group_default_group` DISABLE KEYS */;
INSERT INTO `core_group_default_group` VALUES (3);
/*!40000 ALTER TABLE `core_group_default_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_link`
--

DROP TABLE IF EXISTS `core_link`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `core_link` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `fromEntityTypeId` int(11) NOT NULL,
  `fromId` int(11) NOT NULL,
  `toEntityTypeId` int(11) NOT NULL,
  `toId` int(11) NOT NULL,
  `description` varchar(190) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `deletedAt` datetime DEFAULT NULL,
  `modSeq` int(11) DEFAULT NULL,
  `folderId` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `fromEntityId` (`fromEntityTypeId`,`fromId`,`toEntityTypeId`,`toId`) USING BTREE,
  KEY `toEntity` (`toEntityTypeId`),
  KEY `fromEntityTypeId` (`fromEntityTypeId`),
  KEY `fromId` (`fromId`),
  KEY `toEntityTypeId` (`toEntityTypeId`),
  KEY `toId` (`toId`),
  CONSTRAINT `fromEntity` FOREIGN KEY (`fromEntityTypeId`) REFERENCES `core_entity` (`id`) ON DELETE CASCADE,
  CONSTRAINT `toEntity` FOREIGN KEY (`toEntityTypeId`) REFERENCES `core_entity` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_link`
--

LOCK TABLES `core_link` WRITE;
/*!40000 ALTER TABLE `core_link` DISABLE KEYS */;
/*!40000 ALTER TABLE `core_link` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_module`
--

DROP TABLE IF EXISTS `core_module`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `core_module` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `package` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `version` int(11) NOT NULL,
  `sort_order` int(11) NOT NULL DEFAULT 0,
  `admin_menu` tinyint(1) NOT NULL DEFAULT 0,
  `aclId` int(11) NOT NULL,
  `enabled` tinyint(1) NOT NULL DEFAULT 1,
  `modifiedAt` datetime DEFAULT NULL,
  `modSeq` int(11) DEFAULT NULL,
  `deletedAt` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  KEY `aclId` (`aclId`),
  CONSTRAINT `acl` FOREIGN KEY (`aclId`) REFERENCES `core_acl` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_module`
--

LOCK TABLES `core_module` WRITE;
/*!40000 ALTER TABLE `core_module` DISABLE KEYS */;
INSERT INTO `core_module` VALUES (1,'core','core',176,0,0,5,1,NULL,NULL,NULL),(2,'addressbook','community',53,101,0,9,1,NULL,NULL,NULL),(3,'notes','community',46,102,0,11,1,NULL,NULL,NULL),(4,'googleauthenticator','community',0,103,0,13,1,NULL,NULL,NULL),(5,'comments','community',24,104,0,14,1,NULL,NULL,NULL),(6,'bookmarks','community',8,105,0,15,1,NULL,NULL,NULL),(7,'calendar',NULL,184,106,0,16,1,'2020-07-25 10:50:45',NULL,NULL),(8,'cron',NULL,0,106,1,18,1,'2020-07-25 10:50:46',NULL,NULL),(10,'email',NULL,104,106,0,20,1,'2020-07-25 10:50:46',NULL,NULL),(11,'files',NULL,125,106,0,21,1,'2020-07-25 10:50:46',NULL,NULL),(12,'sieve',NULL,0,106,0,24,1,'2020-07-25 10:50:46',NULL,NULL),(13,'summary',NULL,17,106,0,25,1,'2020-07-25 10:50:47',NULL,NULL),(14,'sync',NULL,49,106,0,26,1,'2020-07-25 10:50:47',NULL,NULL),(15,'tasks',NULL,60,106,0,27,1,'2020-07-25 10:50:47',NULL,NULL),(16,'tools',NULL,0,106,1,28,1,'2020-07-25 10:50:47',NULL,NULL),(17,'dav',NULL,1,106,0,40,1,'2020-07-25 11:12:42',NULL,NULL),(18,'caldav',NULL,32,106,0,41,1,'2020-07-25 11:12:26',NULL,NULL),(19,'calendarexport',NULL,0,106,0,42,1,'2020-07-25 11:12:32',NULL,NULL),(20,'carddav','community',0,106,0,43,1,NULL,NULL,NULL),(21,'customcss',NULL,0,107,1,44,1,'2020-07-25 11:12:39',NULL,NULL),(22,'freebusypermissions',NULL,4,107,0,45,1,'2020-07-25 11:12:54',NULL,NULL),(23,'imapauthenticator','community',1,107,0,46,1,NULL,NULL,NULL),(24,'reminders',NULL,0,108,0,47,1,'2020-07-25 11:13:10',NULL,NULL),(25,'smime',NULL,6,108,0,48,1,'2020-07-25 11:13:15',NULL,NULL),(26,'zpushadmin',NULL,7,108,0,49,1,'2020-07-25 11:13:24',NULL,NULL);
/*!40000 ALTER TABLE `core_module` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_oauth_access_token`
--

DROP TABLE IF EXISTS `core_oauth_access_token`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `core_oauth_access_token` (
  `identifier` varchar(128) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `expiryDateTime` datetime DEFAULT NULL,
  `userIdentifier` int(11) NOT NULL,
  `clientId` int(11) NOT NULL,
  PRIMARY KEY (`identifier`),
  KEY `userIdentifier` (`userIdentifier`),
  KEY `clientId` (`clientId`),
  CONSTRAINT `core_oauth_access_token_ibfk_2` FOREIGN KEY (`userIdentifier`) REFERENCES `core_user` (`id`) ON DELETE CASCADE,
  CONSTRAINT `core_oauth_access_token_ibfk_3` FOREIGN KEY (`clientId`) REFERENCES `core_oauth_client` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_oauth_access_token`
--

LOCK TABLES `core_oauth_access_token` WRITE;
/*!40000 ALTER TABLE `core_oauth_access_token` DISABLE KEYS */;
/*!40000 ALTER TABLE `core_oauth_access_token` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_oauth_client`
--

DROP TABLE IF EXISTS `core_oauth_client`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `core_oauth_client` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(128) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `isConfidential` tinyint(1) NOT NULL,
  `name` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `redirectUri` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `secret` varchar(128) CHARACTER SET ascii COLLATE ascii_bin DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_oauth_client`
--

LOCK TABLES `core_oauth_client` WRITE;
/*!40000 ALTER TABLE `core_oauth_client` DISABLE KEYS */;
/*!40000 ALTER TABLE `core_oauth_client` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_search`
--

DROP TABLE IF EXISTS `core_search`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `core_search` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entityId` int(11) NOT NULL,
  `moduleId` int(11) DEFAULT NULL,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` varchar(190) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `entityTypeId` int(11) NOT NULL,
  `keywords` varchar(190) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `filter` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `modifiedAt` datetime DEFAULT NULL,
  `aclId` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `entityId` (`entityId`,`entityTypeId`),
  KEY `acl_id` (`aclId`),
  KEY `moduleId` (`moduleId`),
  KEY `entityTypeId` (`entityTypeId`),
  KEY `filter` (`filter`),
  KEY `keywords` (`keywords`),
  CONSTRAINT `core_search_ibfk_1` FOREIGN KEY (`entityTypeId`) REFERENCES `core_entity` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_search`
--

LOCK TABLES `core_search` WRITE;
/*!40000 ALTER TABLE `core_search` DISABLE KEYS */;
INSERT INTO `core_search` VALUES (1,1,11,'calendar','calendar',33,'Folder,calendar',NULL,'2020-07-25 11:09:14',38),(2,2,11,'System Administrator','calendar/System Administrator',33,'Folder,System Administrator,calendar/System Administrator',NULL,'2020-07-25 11:09:14',38),(3,3,11,'users','users',33,'Folder,users',NULL,'2020-07-25 11:09:20',21),(4,4,11,'groupofficeadmin','users/groupofficeadmin',33,'Folder,groupofficeadmin,users/groupofficeadmin',NULL,'2020-07-25 11:09:20',39),(5,5,11,'log','log',33,'Folder,log',NULL,'2020-07-25 11:14:12',51),(6,6,11,'addressbook','addressbook',33,'Folder,addressbook',NULL,'2020-07-25 11:14:12',50),(7,7,11,'projects2','projects2',33,'Folder,projects2',NULL,'2020-07-25 11:14:44',21),(8,8,11,'notes','notes',33,'Folder,notes',NULL,'2020-07-25 11:14:44',21),(9,9,11,'tickets','tickets',33,'Folder,tickets',NULL,'2020-07-25 11:14:44',21),(10,10,11,'public','public',33,'Folder,public',NULL,'2020-07-25 11:15:51',21),(11,11,11,'customcss','public/customcss',33,'Folder,customcss,public/customcss',NULL,'2020-07-25 11:15:51',21);
/*!40000 ALTER TABLE `core_search` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_setting`
--

DROP TABLE IF EXISTS `core_setting`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `core_setting` (
  `moduleId` int(11) NOT NULL,
  `name` varchar(190) COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`moduleId`,`name`),
  CONSTRAINT `module` FOREIGN KEY (`moduleId`) REFERENCES `core_module` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_setting`
--

LOCK TABLES `core_setting` WRITE;
/*!40000 ALTER TABLE `core_setting` DISABLE KEYS */;
INSERT INTO `core_setting` VALUES (1,'cacheClearedAt','1595675604'),(1,'databaseVersion','6.4.159'),(1,'defaultCurrency','Rs'),(1,'defaultDecimalSeparator','.'),(1,'defaultThousandSeparator',','),(1,'defaultTimezone','Asia/Calcutta'),(1,'language','en'),(1,'locale','C.UTF-8'),(1,'primaryColor','0E3B83'),(1,'smtpEncryption',NULL),(1,'smtpPassword',NULL),(1,'smtpPort','25'),(1,'systemEmail','postmaster@powermail.mydomainname.com'),(1,'URL','https://powermail.mydomainname.com/groupoffice/'),(1,'userAddressBookId','2'),(2,'lastContactColorIndex','3');
/*!40000 ALTER TABLE `core_setting` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_smtp_account`
--

DROP TABLE IF EXISTS `core_smtp_account`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `core_smtp_account` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `moduleId` int(11) NOT NULL,
  `aclId` int(11) NOT NULL,
  `hostname` varchar(190) COLLATE utf8mb4_unicode_ci NOT NULL,
  `port` int(11) NOT NULL DEFAULT 587,
  `username` varchar(190) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `password` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `encryption` enum('tls','ssl') COLLATE utf8mb4_unicode_ci DEFAULT 'tls',
  `verifyCertificate` tinyint(1) NOT NULL DEFAULT 1,
  `fromName` varchar(190) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fromEmail` varchar(190) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `moduleId` (`moduleId`),
  KEY `aclId` (`aclId`),
  CONSTRAINT `core_smtp_account_ibfk_1` FOREIGN KEY (`moduleId`) REFERENCES `core_module` (`id`) ON DELETE CASCADE,
  CONSTRAINT `core_smtp_account_ibfk_2` FOREIGN KEY (`aclId`) REFERENCES `core_acl` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_smtp_account`
--

LOCK TABLES `core_smtp_account` WRITE;
/*!40000 ALTER TABLE `core_smtp_account` DISABLE KEYS */;
/*!40000 ALTER TABLE `core_smtp_account` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_user`
--

DROP TABLE IF EXISTS `core_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `core_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `displayName` varchar(190) COLLATE utf8mb4_unicode_ci NOT NULL,
  `avatarId` binary(40) DEFAULT NULL,
  `enabled` tinyint(1) NOT NULL DEFAULT 1,
  `email` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `recoveryEmail` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `recoveryHash` varchar(40) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `recoverySendAt` datetime DEFAULT NULL,
  `lastLogin` datetime DEFAULT NULL,
  `createdAt` datetime DEFAULT NULL,
  `modifiedAt` datetime DEFAULT NULL,
  `dateFormat` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'd-m-Y',
  `shortDateInList` tinyint(1) NOT NULL DEFAULT 1,
  `timeFormat` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'G:i',
  `thousandsSeparator` varchar(1) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '.',
  `decimalSeparator` varchar(1) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT ',',
  `currency` char(3) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `loginCount` int(11) NOT NULL DEFAULT 0,
  `max_rows_list` tinyint(4) NOT NULL DEFAULT 20,
  `timezone` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Europe/Amsterdam',
  `start_module` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'summary',
  `language` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'en',
  `theme` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Paper',
  `firstWeekday` tinyint(4) NOT NULL DEFAULT 1,
  `sort_name` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'first_name',
  `muser_id` int(11) NOT NULL DEFAULT 0,
  `mute_sound` tinyint(1) NOT NULL DEFAULT 0,
  `mute_reminder_sound` tinyint(1) NOT NULL DEFAULT 0,
  `mute_new_mail_sound` tinyint(1) NOT NULL DEFAULT 0,
  `show_smilies` tinyint(1) NOT NULL DEFAULT 1,
  `auto_punctuation` tinyint(1) NOT NULL DEFAULT 0,
  `listSeparator` char(3) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT ';',
  `textSeparator` char(3) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '"',
  `files_folder_id` int(11) NOT NULL DEFAULT 0,
  `disk_quota` bigint(20) DEFAULT NULL,
  `disk_usage` bigint(20) NOT NULL DEFAULT 0,
  `mail_reminders` tinyint(1) NOT NULL DEFAULT 0,
  `popup_reminders` tinyint(1) NOT NULL DEFAULT 0,
  `popup_emails` tinyint(1) NOT NULL DEFAULT 0,
  `holidayset` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sort_email_addresses_by_time` tinyint(1) NOT NULL DEFAULT 0,
  `no_reminders` tinyint(1) NOT NULL DEFAULT 0,
  `last_password_change` int(11) NOT NULL DEFAULT 0,
  `force_password_change` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  KEY `fk_user_avatar_id_idx` (`avatarId`),
  CONSTRAINT `fk_user_avatar_id` FOREIGN KEY (`avatarId`) REFERENCES `core_blob` (`id`) ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_user`
--

LOCK TABLES `core_user` WRITE;
/*!40000 ALTER TABLE `core_user` DISABLE KEYS */;
INSERT INTO `core_user` VALUES (1,'groupofficeadmin','System Administrator',NULL,1,'support@technoinfotech.com','support@technoinfotech.com',NULL,NULL,'2020-07-25 11:09:13','2020-07-25 10:50:43','2020-07-25 11:09:13','d-m-Y',1,'G:i','.',',','‚Ç¨',1,20,'Europe/Amsterdam','summary','en','Paper',1,'first_name',0,0,0,0,1,0,';','\"',0,NULL,0,0,0,0,NULL,0,0,0,0);
/*!40000 ALTER TABLE `core_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_user_custom_fields`
--

DROP TABLE IF EXISTS `core_user_custom_fields`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `core_user_custom_fields` (
  `id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `core_user_custom_fields_ibfk_1` FOREIGN KEY (`id`) REFERENCES `core_user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_user_custom_fields`
--

LOCK TABLES `core_user_custom_fields` WRITE;
/*!40000 ALTER TABLE `core_user_custom_fields` DISABLE KEYS */;
/*!40000 ALTER TABLE `core_user_custom_fields` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_user_default_group`
--

DROP TABLE IF EXISTS `core_user_default_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `core_user_default_group` (
  `groupId` int(11) NOT NULL,
  PRIMARY KEY (`groupId`),
  CONSTRAINT `core_user_default_group_ibfk_1` FOREIGN KEY (`groupId`) REFERENCES `core_group` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_user_default_group`
--

LOCK TABLES `core_user_default_group` WRITE;
/*!40000 ALTER TABLE `core_user_default_group` DISABLE KEYS */;
/*!40000 ALTER TABLE `core_user_default_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_user_group`
--

DROP TABLE IF EXISTS `core_user_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `core_user_group` (
  `groupId` int(11) NOT NULL,
  `userId` int(11) NOT NULL,
  PRIMARY KEY (`groupId`,`userId`),
  KEY `userId` (`userId`),
  CONSTRAINT `core_user_group_ibfk_1` FOREIGN KEY (`groupId`) REFERENCES `core_group` (`id`) ON DELETE CASCADE,
  CONSTRAINT `core_user_group_ibfk_2` FOREIGN KEY (`userId`) REFERENCES `core_user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_user_group`
--

LOCK TABLES `core_user_group` WRITE;
/*!40000 ALTER TABLE `core_user_group` DISABLE KEYS */;
INSERT INTO `core_user_group` VALUES (1,1),(2,1),(4,1);
/*!40000 ALTER TABLE `core_user_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dav_calendar_changes`
--

DROP TABLE IF EXISTS `dav_calendar_changes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dav_calendar_changes` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `uri` varbinary(200) NOT NULL,
  `synctoken` int(11) unsigned NOT NULL,
  `calendarid` int(11) unsigned NOT NULL,
  `operation` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `calendarid_synctoken` (`calendarid`,`synctoken`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dav_calendar_changes`
--

LOCK TABLES `dav_calendar_changes` WRITE;
/*!40000 ALTER TABLE `dav_calendar_changes` DISABLE KEYS */;
/*!40000 ALTER TABLE `dav_calendar_changes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dav_events`
--

DROP TABLE IF EXISTS `dav_events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dav_events` (
  `id` int(11) NOT NULL,
  `mtime` int(11) NOT NULL,
  `data` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `uri` varchar(512) CHARACTER SET ascii COLLATE ascii_bin NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `uri` (`uri`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dav_events`
--

LOCK TABLES `dav_events` WRITE;
/*!40000 ALTER TABLE `dav_events` DISABLE KEYS */;
/*!40000 ALTER TABLE `dav_events` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dav_locks`
--

DROP TABLE IF EXISTS `dav_locks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dav_locks` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `owner` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `timeout` int(10) unsigned DEFAULT NULL,
  `created` int(11) DEFAULT NULL,
  `token` varbinary(100) DEFAULT NULL,
  `scope` tinyint(4) DEFAULT NULL,
  `depth` tinyint(4) DEFAULT NULL,
  `uri` varbinary(1000) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `token` (`token`),
  KEY `uri` (`uri`(100))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dav_locks`
--

LOCK TABLES `dav_locks` WRITE;
/*!40000 ALTER TABLE `dav_locks` DISABLE KEYS */;
/*!40000 ALTER TABLE `dav_locks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dav_tasks`
--

DROP TABLE IF EXISTS `dav_tasks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dav_tasks` (
  `id` int(11) NOT NULL,
  `mtime` int(11) NOT NULL,
  `data` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `uri` varchar(512) CHARACTER SET ascii COLLATE ascii_bin NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `uri` (`uri`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dav_tasks`
--

LOCK TABLES `dav_tasks` WRITE;
/*!40000 ALTER TABLE `dav_tasks` DISABLE KEYS */;
/*!40000 ALTER TABLE `dav_tasks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `em_accounts`
--

DROP TABLE IF EXISTS `em_accounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `em_accounts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT 0,
  `acl_id` int(11) NOT NULL DEFAULT 0,
  `type` varchar(4) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `host` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `port` int(11) NOT NULL DEFAULT 0,
  `deprecated_use_ssl` tinyint(1) NOT NULL DEFAULT 0,
  `novalidate_cert` tinyint(1) NOT NULL DEFAULT 0,
  `username` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `password` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `imap_encryption` char(3) COLLATE utf8mb4_unicode_ci NOT NULL,
  `imap_allow_self_signed` tinyint(1) NOT NULL DEFAULT 1,
  `mbroot` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `sent` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT 'Sent',
  `drafts` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT 'Drafts',
  `trash` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Trash',
  `spam` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Spam',
  `smtp_host` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `smtp_port` int(11) NOT NULL,
  `smtp_encryption` char(3) COLLATE utf8mb4_unicode_ci NOT NULL,
  `smtp_allow_self_signed` tinyint(1) NOT NULL DEFAULT 0,
  `smtp_username` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `smtp_password` varchar(512) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `password_encrypted` tinyint(4) NOT NULL DEFAULT 0,
  `ignore_sent_folder` tinyint(1) NOT NULL DEFAULT 0,
  `sieve_port` int(11) NOT NULL,
  `sieve_usetls` tinyint(1) NOT NULL DEFAULT 1,
  `check_mailboxes` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `do_not_mark_as_read` tinyint(1) NOT NULL DEFAULT 0,
  `signature_below_reply` tinyint(1) NOT NULL DEFAULT 0,
  `full_reply_headers` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `em_accounts`
--

LOCK TABLES `em_accounts` WRITE;
/*!40000 ALTER TABLE `em_accounts` DISABLE KEYS */;
/*!40000 ALTER TABLE `em_accounts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `em_accounts_collapsed`
--

DROP TABLE IF EXISTS `em_accounts_collapsed`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `em_accounts_collapsed` (
  `account_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`account_id`,`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `em_accounts_collapsed`
--

LOCK TABLES `em_accounts_collapsed` WRITE;
/*!40000 ALTER TABLE `em_accounts_collapsed` DISABLE KEYS */;
/*!40000 ALTER TABLE `em_accounts_collapsed` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `em_accounts_sort`
--

DROP TABLE IF EXISTS `em_accounts_sort`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `em_accounts_sort` (
  `account_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `order` int(11) NOT NULL,
  PRIMARY KEY (`account_id`,`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `em_accounts_sort`
--

LOCK TABLES `em_accounts_sort` WRITE;
/*!40000 ALTER TABLE `em_accounts_sort` DISABLE KEYS */;
/*!40000 ALTER TABLE `em_accounts_sort` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `em_aliases`
--

DROP TABLE IF EXISTS `em_aliases`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `em_aliases` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `account_id` int(11) NOT NULL,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `signature` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `default` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `account_id` (`account_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `em_aliases`
--

LOCK TABLES `em_aliases` WRITE;
/*!40000 ALTER TABLE `em_aliases` DISABLE KEYS */;
/*!40000 ALTER TABLE `em_aliases` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `em_contacts_last_mail_times`
--

DROP TABLE IF EXISTS `em_contacts_last_mail_times`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `em_contacts_last_mail_times` (
  `contact_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `last_mail_time` int(11) NOT NULL,
  PRIMARY KEY (`contact_id`,`user_id`),
  KEY `last_mail_time` (`last_mail_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `em_contacts_last_mail_times`
--

LOCK TABLES `em_contacts_last_mail_times` WRITE;
/*!40000 ALTER TABLE `em_contacts_last_mail_times` DISABLE KEYS */;
/*!40000 ALTER TABLE `em_contacts_last_mail_times` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `em_filters`
--

DROP TABLE IF EXISTS `em_filters`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `em_filters` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `account_id` int(11) NOT NULL DEFAULT 0,
  `field` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `keyword` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `folder` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `priority` int(11) NOT NULL DEFAULT 0,
  `mark_as_read` enum('0','1') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `em_filters`
--

LOCK TABLES `em_filters` WRITE;
/*!40000 ALTER TABLE `em_filters` DISABLE KEYS */;
/*!40000 ALTER TABLE `em_filters` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `em_folders`
--

DROP TABLE IF EXISTS `em_folders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `em_folders` (
  `id` int(11) NOT NULL DEFAULT 0,
  `account_id` int(11) NOT NULL DEFAULT 0,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `subscribed` enum('0','1') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0',
  `parent_id` int(11) NOT NULL DEFAULT 0,
  `delimiter` char(1) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `sort_order` tinyint(4) NOT NULL DEFAULT 0,
  `msgcount` int(11) NOT NULL DEFAULT 0,
  `unseen` int(11) NOT NULL DEFAULT 0,
  `auto_check` enum('0','1') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0',
  `can_have_children` tinyint(1) NOT NULL,
  `no_select` tinyint(1) DEFAULT NULL,
  `sort` longtext COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `account_id` (`account_id`),
  KEY `parent_id` (`parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `em_folders`
--

LOCK TABLES `em_folders` WRITE;
/*!40000 ALTER TABLE `em_folders` DISABLE KEYS */;
/*!40000 ALTER TABLE `em_folders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `em_folders_expanded`
--

DROP TABLE IF EXISTS `em_folders_expanded`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `em_folders_expanded` (
  `folder_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`folder_id`,`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `em_folders_expanded`
--

LOCK TABLES `em_folders_expanded` WRITE;
/*!40000 ALTER TABLE `em_folders_expanded` DISABLE KEYS */;
/*!40000 ALTER TABLE `em_folders_expanded` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `em_labels`
--

DROP TABLE IF EXISTS `em_labels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `em_labels` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `flag` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `color` varchar(6) COLLATE utf8mb4_unicode_ci NOT NULL,
  `account_id` int(11) NOT NULL,
  `default` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `em_labels`
--

LOCK TABLES `em_labels` WRITE;
/*!40000 ALTER TABLE `em_labels` DISABLE KEYS */;
/*!40000 ALTER TABLE `em_labels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `em_links`
--

DROP TABLE IF EXISTS `em_links`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `em_links` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT 0,
  `from` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `to` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `subject` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `time` int(11) NOT NULL DEFAULT 0,
  `path` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ctime` int(11) NOT NULL,
  `mtime` int(11) NOT NULL DEFAULT 0,
  `muser_id` int(11) NOT NULL DEFAULT 0,
  `acl_id` int(11) NOT NULL,
  `uid` varchar(255) CHARACTER SET ascii COLLATE ascii_bin NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `account_id` (`user_id`),
  KEY `uid` (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `em_links`
--

LOCK TABLES `em_links` WRITE;
/*!40000 ALTER TABLE `em_links` DISABLE KEYS */;
/*!40000 ALTER TABLE `em_links` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `em_messages_cache`
--

DROP TABLE IF EXISTS `em_messages_cache`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `em_messages_cache` (
  `folder_id` int(11) NOT NULL,
  `uid` int(11) NOT NULL,
  `account_id` int(11) NOT NULL,
  `new` enum('0','1') COLLATE utf8mb4_unicode_ci NOT NULL,
  `subject` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `from` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `size` int(11) NOT NULL,
  `udate` int(11) NOT NULL,
  `attachments` enum('0','1') COLLATE utf8mb4_unicode_ci NOT NULL,
  `flagged` enum('0','1') COLLATE utf8mb4_unicode_ci NOT NULL,
  `answered` enum('0','1') COLLATE utf8mb4_unicode_ci NOT NULL,
  `forwarded` tinyint(1) NOT NULL,
  `priority` tinyint(4) NOT NULL,
  `to` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `serialized_message_object` mediumtext COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`folder_id`,`uid`),
  KEY `account_id` (`account_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `em_messages_cache`
--

LOCK TABLES `em_messages_cache` WRITE;
/*!40000 ALTER TABLE `em_messages_cache` DISABLE KEYS */;
/*!40000 ALTER TABLE `em_messages_cache` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `em_portlet_folders`
--

DROP TABLE IF EXISTS `em_portlet_folders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `em_portlet_folders` (
  `account_id` int(11) NOT NULL,
  `folder_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` int(11) NOT NULL,
  `mtime` int(11) NOT NULL,
  PRIMARY KEY (`account_id`,`folder_name`,`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `em_portlet_folders`
--

LOCK TABLES `em_portlet_folders` WRITE;
/*!40000 ALTER TABLE `em_portlet_folders` DISABLE KEYS */;
/*!40000 ALTER TABLE `em_portlet_folders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `email_default_email_account_templates`
--

DROP TABLE IF EXISTS `email_default_email_account_templates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `email_default_email_account_templates` (
  `account_id` int(11) NOT NULL,
  `template_id` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`account_id`),
  KEY `template_id` (`template_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `email_default_email_account_templates`
--

LOCK TABLES `email_default_email_account_templates` WRITE;
/*!40000 ALTER TABLE `email_default_email_account_templates` DISABLE KEYS */;
/*!40000 ALTER TABLE `email_default_email_account_templates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `email_default_email_templates`
--

DROP TABLE IF EXISTS `email_default_email_templates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `email_default_email_templates` (
  `user_id` int(11) NOT NULL,
  `template_id` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`user_id`),
  KEY `template_id` (`template_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `email_default_email_templates`
--

LOCK TABLES `email_default_email_templates` WRITE;
/*!40000 ALTER TABLE `email_default_email_templates` DISABLE KEYS */;
/*!40000 ALTER TABLE `email_default_email_templates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `emp_folders`
--

DROP TABLE IF EXISTS `emp_folders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `emp_folders` (
  `folder_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `mtime` int(11) NOT NULL,
  PRIMARY KEY (`folder_id`,`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `emp_folders`
--

LOCK TABLES `emp_folders` WRITE;
/*!40000 ALTER TABLE `emp_folders` DISABLE KEYS */;
/*!40000 ALTER TABLE `emp_folders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fb_acl`
--

DROP TABLE IF EXISTS `fb_acl`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fb_acl` (
  `user_id` int(11) NOT NULL,
  `acl_id` int(11) NOT NULL,
  PRIMARY KEY (`user_id`,`acl_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fb_acl`
--

LOCK TABLES `fb_acl` WRITE;
/*!40000 ALTER TABLE `fb_acl` DISABLE KEYS */;
/*!40000 ALTER TABLE `fb_acl` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fs_bookmarks`
--

DROP TABLE IF EXISTS `fs_bookmarks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fs_bookmarks` (
  `folder_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`folder_id`,`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fs_bookmarks`
--

LOCK TABLES `fs_bookmarks` WRITE;
/*!40000 ALTER TABLE `fs_bookmarks` DISABLE KEYS */;
/*!40000 ALTER TABLE `fs_bookmarks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fs_filehandlers`
--

DROP TABLE IF EXISTS `fs_filehandlers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fs_filehandlers` (
  `user_id` int(11) NOT NULL,
  `extension` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `cls` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`user_id`,`extension`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fs_filehandlers`
--

LOCK TABLES `fs_filehandlers` WRITE;
/*!40000 ALTER TABLE `fs_filehandlers` DISABLE KEYS */;
/*!40000 ALTER TABLE `fs_filehandlers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fs_files`
--

DROP TABLE IF EXISTS `fs_files`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fs_files` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `folder_id` int(11) NOT NULL,
  `name` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `locked_user_id` int(11) NOT NULL DEFAULT 0,
  `status_id` int(11) NOT NULL DEFAULT 0,
  `ctime` int(11) NOT NULL DEFAULT 0,
  `mtime` int(11) NOT NULL DEFAULT 0,
  `muser_id` int(11) NOT NULL DEFAULT 0,
  `size` bigint(20) NOT NULL,
  `user_id` int(11) NOT NULL,
  `comment` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `extension` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `expire_time` int(11) NOT NULL DEFAULT 0,
  `random_code` char(11) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `delete_when_expired` tinyint(1) NOT NULL DEFAULT 0,
  `content_expire_date` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `folder_id_2` (`folder_id`,`name`),
  KEY `folder_id` (`folder_id`),
  KEY `name` (`name`),
  KEY `extension` (`extension`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fs_files`
--

LOCK TABLES `fs_files` WRITE;
/*!40000 ALTER TABLE `fs_files` DISABLE KEYS */;
/*!40000 ALTER TABLE `fs_files` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fs_files_custom_fields`
--

DROP TABLE IF EXISTS `fs_files_custom_fields`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fs_files_custom_fields` (
  `id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fs_files_custom_fields_ibfk_1` FOREIGN KEY (`id`) REFERENCES `fs_files` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fs_files_custom_fields`
--

LOCK TABLES `fs_files_custom_fields` WRITE;
/*!40000 ALTER TABLE `fs_files_custom_fields` DISABLE KEYS */;
/*!40000 ALTER TABLE `fs_files_custom_fields` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fs_folder_pref`
--

DROP TABLE IF EXISTS `fs_folder_pref`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fs_folder_pref` (
  `folder_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `thumbs` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`folder_id`,`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fs_folder_pref`
--

LOCK TABLES `fs_folder_pref` WRITE;
/*!40000 ALTER TABLE `fs_folder_pref` DISABLE KEYS */;
/*!40000 ALTER TABLE `fs_folder_pref` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fs_folders`
--

DROP TABLE IF EXISTS `fs_folders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fs_folders` (
  `user_id` int(11) NOT NULL DEFAULT 0,
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parent_id` int(11) NOT NULL,
  `name` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `visible` tinyint(1) NOT NULL DEFAULT 0,
  `acl_id` int(11) NOT NULL DEFAULT 0,
  `comment` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `thumbs` tinyint(1) NOT NULL DEFAULT 1,
  `ctime` int(11) NOT NULL,
  `mtime` int(11) NOT NULL,
  `muser_id` int(11) NOT NULL DEFAULT 0,
  `quota_user_id` int(11) NOT NULL DEFAULT 0,
  `readonly` tinyint(1) NOT NULL DEFAULT 0,
  `cm_state` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `apply_state` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `parent_id_3` (`parent_id`,`name`),
  KEY `name` (`name`),
  KEY `parent_id` (`parent_id`),
  KEY `visible` (`visible`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fs_folders`
--

LOCK TABLES `fs_folders` WRITE;
/*!40000 ALTER TABLE `fs_folders` DISABLE KEYS */;
INSERT INTO `fs_folders` VALUES (1,1,0,'calendar',0,38,NULL,1,1595675354,1595675354,1,1,1,NULL,0),(1,2,1,'System Administrator',0,38,NULL,1,1595675354,1595675354,1,1,1,NULL,0),(1,3,0,'users',0,21,NULL,1,1595675360,1595675360,1,1,1,NULL,0),(1,4,3,'groupofficeadmin',1,39,NULL,1,1595675360,1595675360,1,1,1,NULL,0),(1,5,0,'log',0,51,NULL,1,1595675360,1595675652,1,1,1,NULL,0),(1,6,0,'addressbook',0,50,NULL,1,1595675652,1595675652,1,1,0,NULL,0),(1,7,0,'projects2',0,21,NULL,1,1595675684,1595675684,1,1,1,NULL,0),(1,8,0,'notes',0,21,NULL,1,1595675684,1595675684,1,1,1,NULL,0),(1,9,0,'tickets',0,21,NULL,1,1595675684,1595675684,1,1,1,NULL,0),(1,10,0,'public',0,21,NULL,1,1595675751,1595675751,1,1,1,NULL,0),(1,11,10,'customcss',0,0,NULL,1,1595675751,1595675751,1,1,0,NULL,0);
/*!40000 ALTER TABLE `fs_folders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fs_folders_custom_fields`
--

DROP TABLE IF EXISTS `fs_folders_custom_fields`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fs_folders_custom_fields` (
  `id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fs_folders_custom_fields_ibfk_1` FOREIGN KEY (`id`) REFERENCES `fs_folders` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fs_folders_custom_fields`
--

LOCK TABLES `fs_folders_custom_fields` WRITE;
/*!40000 ALTER TABLE `fs_folders_custom_fields` DISABLE KEYS */;
/*!40000 ALTER TABLE `fs_folders_custom_fields` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fs_new_files`
--

DROP TABLE IF EXISTS `fs_new_files`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fs_new_files` (
  `file_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  KEY `file_id` (`file_id`,`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fs_new_files`
--

LOCK TABLES `fs_new_files` WRITE;
/*!40000 ALTER TABLE `fs_new_files` DISABLE KEYS */;
/*!40000 ALTER TABLE `fs_new_files` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fs_notification_messages`
--

DROP TABLE IF EXISTS `fs_notification_messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fs_notification_messages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `modified_user_id` int(11) NOT NULL,
  `type` int(11) NOT NULL,
  `arg1` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `arg2` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `mtime` int(11) NOT NULL,
  `status` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`,`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fs_notification_messages`
--

LOCK TABLES `fs_notification_messages` WRITE;
/*!40000 ALTER TABLE `fs_notification_messages` DISABLE KEYS */;
/*!40000 ALTER TABLE `fs_notification_messages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fs_notifications`
--

DROP TABLE IF EXISTS `fs_notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fs_notifications` (
  `folder_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`folder_id`,`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fs_notifications`
--

LOCK TABLES `fs_notifications` WRITE;
/*!40000 ALTER TABLE `fs_notifications` DISABLE KEYS */;
/*!40000 ALTER TABLE `fs_notifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fs_shared_cache`
--

DROP TABLE IF EXISTS `fs_shared_cache`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fs_shared_cache` (
  `user_id` int(11) NOT NULL,
  `folder_id` int(11) NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `path` text COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`user_id`,`folder_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fs_shared_cache`
--

LOCK TABLES `fs_shared_cache` WRITE;
/*!40000 ALTER TABLE `fs_shared_cache` DISABLE KEYS */;
/*!40000 ALTER TABLE `fs_shared_cache` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fs_shared_root_folders`
--

DROP TABLE IF EXISTS `fs_shared_root_folders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fs_shared_root_folders` (
  `user_id` int(11) NOT NULL,
  `folder_id` int(11) NOT NULL,
  PRIMARY KEY (`user_id`,`folder_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fs_shared_root_folders`
--

LOCK TABLES `fs_shared_root_folders` WRITE;
/*!40000 ALTER TABLE `fs_shared_root_folders` DISABLE KEYS */;
/*!40000 ALTER TABLE `fs_shared_root_folders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fs_status_history`
--

DROP TABLE IF EXISTS `fs_status_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fs_status_history` (
  `id` int(11) NOT NULL DEFAULT 0,
  `link_id` int(11) NOT NULL DEFAULT 0,
  `status_id` int(11) NOT NULL DEFAULT 0,
  `user_id` int(11) NOT NULL DEFAULT 0,
  `ctime` int(11) NOT NULL DEFAULT 0,
  `comments` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `link_id` (`link_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fs_status_history`
--

LOCK TABLES `fs_status_history` WRITE;
/*!40000 ALTER TABLE `fs_status_history` DISABLE KEYS */;
/*!40000 ALTER TABLE `fs_status_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fs_statuses`
--

DROP TABLE IF EXISTS `fs_statuses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fs_statuses` (
  `id` int(11) NOT NULL DEFAULT 0,
  `name` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fs_statuses`
--

LOCK TABLES `fs_statuses` WRITE;
/*!40000 ALTER TABLE `fs_statuses` DISABLE KEYS */;
/*!40000 ALTER TABLE `fs_statuses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fs_templates`
--

DROP TABLE IF EXISTS `fs_templates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fs_templates` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `name` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `acl_id` int(11) NOT NULL,
  `content` mediumblob NOT NULL,
  `extension` char(4) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fs_templates`
--

LOCK TABLES `fs_templates` WRITE;
/*!40000 ALTER TABLE `fs_templates` DISABLE KEYS */;
INSERT INTO `fs_templates` VALUES (1,1,'Microsoft Word document',22,'PK\0\0H∞B\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0_rels/.rels≠íMKAÜÔ˝CÓ›l+à»Œˆ\"Bo\"ıÑôÏÓ–Œ3i≠ˇﬁA\n∫Pä†«ºyÛ“mŒ˛†NúããA√™iAq0—∫0jx€=/`”/∫W>ê‘Jô\\*™ﬁÑ¢aIèà≈LÏ©41q®õ!fOR«<b\"≥ßëq›∂˜ò2†ü1’÷j»[ªµ˚H¸76z≤$Ñ&f^¶\\Ø≥8.Nyd—`£y©q˘j4ïx]h˝{°8ŒS4GœAÆyÒY8X∂∑ï(•[Fwˇi4o|Àº«l—^‚ãÕ¢√ŸÙüPKË–#Ÿ\0\0\0=\0\0PK\0\0H∞B\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0word/_rels/document.xml.rels≠ëM\n¬0Ö˜û\"Ãﬁ¶Uë¶nDp+ı\01ù∂¡6	…(z{äZ(‚¬Â¸}Ô1/__˚é]–mçÄ,IÅ°Q∂“¶p(∑”%¨ãIæ«NR\\	≠vÅ≈¥Dn≈yP-ˆ2$÷°âì⁄˙^R,}√ùT\'Ÿ ü•ÈÇ˚O&€U¸Æ Äï7áø∞m]kÖ´Œ=\Z\Zë‡ÅnÜHîæA®ì»>.?˚ß|m\rïÚÿ·€¡´ıÕƒ¸Ø?@¢òÂÁûùßÖIŒ·wPK˘/0¿≈\0\0\0\0\0PK\0\0H∞B\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0word/settings.xmlEéK¬0D˜ú\"Úí≤‡Së≤„¿Bk†RbG±°¿È	+ñ£73zª˝+EÛƒ\"#ìáf·¿ ı<åtÛp>Ê0¢ÅÜô–√ˆ›l7µÇ™µ%¶>ê¥ìáªjn≠ï˛é)»Ç3ReW.)hçÂf\'.C.‹£Hù¶hóŒ≠l\n#AW/?Ã…Lm∆“#i’iÿ\ZQO·rTŒµÚ—√⁄mÿ˛]∫/PKe˙÷\"•\0\0\0–\0\0\0PK\0\0H∞B\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0word/fontTable.xml≠ê¡N√0ÜÔ<Eî;KŸM’∫		q‰\0„º‘]#%qáÜæ=Y€ù(“@ª%ˆÔˇ˚ÌÌ˛ÀY—c`Cæí´B\nÙöj„Oï¸8º‹o§‡æK+9 À˝Ónõ Ü|dë«=ó°ímå]©Îä:Ùπ◊PpÛ7ú5ç—¯L˙”°èj]è*†Öò—‹öéÂÏñÆqKÍ.êFÊú’Ÿ…œÅÒr7ß©Ù‡rËÉq»‚ìx#ì@∑œöl%ãB™qú±√•\ZF˘ÿËL‘Ì•ﬁC0p¥xn©	ˆ˙>∏#ŸE÷˙÷¨ß,YF-Æ≈…0ˇu≈-77øÂØ˚-£˛¥ﬂ¸‡›7PKëàZ]\0\0\0\0PK\0\0H∞B\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0word/styles.xml•TQo⁄0~ﬂØà¸Nh£5Tå©	±©–Ω…Aº9∂Âs\ZËØüíj¥†xâÌÛ›ÂæÔ;ﬂ˝√6¡\Z‚JF¨s”f X%\\n\"ˆº|lıY@dBIåÿâ=ø‹≤;Å∏xIÉ\"b©µzÜßò›(ç“›≠ï…¿∫£ŸÑÖ2â6*F\"ó>a∑›ÓÖp…Üu¬†ZßIƒ ç+®ÿùvˇ÷``c@ß•ªÑÃ{øÄàÿ\\C.l∞,,ØqkÎÎ*Qi◊øå_\nû®b¨§5J‘nkTESÆµquér´&;ù¢§⁄Àöºt\nﬂrôjytÈºPÃyƒñ<s¸Ã±ûT“„à)b3ïrL∏L∏7!ê‚¸ŒÉHÚÈH“ë,ey± ‘Å´±™˙µ∂uø÷ñ1Ω∑	êg[Òƒ•Oyk:?¨„5mçKSÖ≤ıº®ñ@√J°”íuæ5—lÇ‡ªl_”\nìüÚò`ÑÏÙî¸ã®ÁŒgèWCÃKx∞∂h\\GwÀZ°kDÙ¥k•uA9à≈[»a|™Ô»p™∫è}/Zˇàh˝3πÔ5·~È9˝Æí›’ÏF¯•tüÅ¯∂	‚\'{\Zl\rÍ#⁄€ˇ–ûÓà˜pûd˝&\0∆†≠õ—÷?¨öl3.qûg+7˙Ωº˙Â·©˝wLçgÿ‹ﬁ5·v*‹^¿Ï]fØlözG√PK’îqË\0\0´\0\0PK\0\0H∞B\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0word/document.xmlçRÀn¬0º˜+\"ﬂ¡°TàF.®∑VH–0Œ&±d{#{!–ØØM–K≈≈õ—Ãæ&ª⁄\\åNŒ‡ºBõ≥Ÿ4e	XâÖ≤UŒæì%K<	[çrvœ6ÎóUõ(O,%°ÇıÊÏ‰lÊe\rF¯âQ“°«í&MÜe©$ÙÅı.g5Qìqﬁ\'M±∏ù†´xó≤Ì{Ò◊4]pZPò◊◊™ÒCµÛ˝œF∫ˆôÆ-∫¢q(¡˚`Ñ—]_#îÀÃ“\'éu∆åÊôŒÖÌCÀøÉl;í≠É˝G,Æ16∑gÁnaOW\rIõùÖŒôè e|Ω‚£¢{‚7àù\"R$uJ∫6c%⁄â\nb≠ ¨ˆ?Å©√π,ñÛpm4u6{OÉ‡S∏$éHÑ&RÛ∑®*	¬_O#®Nt5àb\ZJ∫\'9U’ê∞ÈAﬂÍÎd›®•	∫§2Bwl4vÁêÜ=J°}øÖï∂ Öu√!\rºvácÔ◊`úÊ˜ã_ˇPKó˙Åly\0\06\0\0PK\0\0H∞B\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0docProps/app.xmlù–=k√0‡Ωø¬à¨∂TcL≤BCÈh∑t3ätN¨§sp˛}’öÃè˜xxÔ¯v±SqÅòåwy¨)¿)Øç;v‰Ω)◊§H(ùñìw–ë+$≤¸-˙\0\r§\".u‰Ñ6î&u+Sïcóì—G+1èÒH˝8\Zœ^Õ“ö±ñ¬Ç‡4Ë2¸Å‰W‹\\ø®ˆÍª_˙ËØ!{Ç˜Â‘Çqz¯SìQÛÒbo^4⁄T¨™´zµ7n^Üœu;¥Mq∑0‰∂gPH∆,[Ìf3È≤ÊÙﬁ„Ùˆ#ÒPK(Îõ‚\0\0\0h\0\0PK\0\0H∞B\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0docProps/core.xmlmë[O¬0ÜÔ˝KÔ∑∂ Dõm\\h∏íƒDåÜª¶˚’ıê∂2¯˜∂&\ZÓ˙Â}˙ÙñãΩÍ≤8/çÆ- @”H›VËuΩÃÔPÊ◊\rÔåÜ\n¿£E}S\nÀÑqÏå$¯,ä¥g¬VhÇe{±≈}	√„qt-∂\\|ÒÑê9Vx√«Iò€—àN FåJ˚Ì∫A–(–¡cZP¸À*ÆÓ8át\0ß¸UxHFrÔÂHı}_Ù”Åã˜ß¯}ıÙ2<5ó:}ï\0Tó\'5xÄ&ãvºÿ9yõ><Æó®û:Õ…,ßÛ5%lvœncdS‚ä‰<Æç´W‡‰ßŒ“π.Vï‡1K›8ÿ…TiMJ|9”ﬂ‚ÍPKø¬i\0\0\0\0PK\0\0H∞B\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0[Content_Types].xmlΩî1O√0Ö˜˛ä»+JBI: 1Bá0#c_ãƒ∂|¶¥ˇûsh#®¥∞X≤¸Ó}œÁìãÂfËì5x‘÷îÏ<ÀYFZ•M[≤á˙6ΩbÀjQ‘[òê÷`…∫‹5Á(;f÷Å°ì∆˙A⁄˙ñ;!üE¸\"œ/π¥&Ä	ià¨*Ó	ÁµÇd%|∏îå?zËëgqe…Õ{AdñL8◊k)Â„k£>—“)Vé\ZÏ¥√30˛=È’zµ√)+_e$ˇ74B‘\\å–üÒl”h	SËËÊºïÄH~tÉΩÛlÑÜ†µxÍ·Ù&Î˘>Ñm—Ö—wˇÒÌO`:Ñ6árêpÂ≠CN¿£c¿Ü*®î≤8AÓ¡ƒñ÷ˇbˆ£´øˇãÍ\rPKcÓ§a*\0\0^\0\0PK\0\0\0H∞BË–#Ÿ\0\0\0=\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0_rels/.relsPK\0\0\0H∞B˘/0¿≈\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0word/_rels/document.xml.relsPK\0\0\0H∞Be˙÷\"•\0\0\0–\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0!\0\0word/settings.xmlPK\0\0\0H∞BëàZ]\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0word/fontTable.xmlPK\0\0\0H∞B’îqË\0\0´\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0F\0\0word/styles.xmlPK\0\0\0H∞Bó˙Åly\0\06\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0õ\0\0word/document.xmlPK\0\0\0H∞B(Îõ‚\0\0\0h\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0S\0\0docProps/app.xmlPK\0\0\0H∞Bø¬i\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0s	\0\0docProps/core.xmlPK\0\0\0H∞BcÓ§a*\0\0^\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0—\n\0\0[Content_Types].xmlPK\0\0\0\0	\0	\0<\0\0<\0\0\0\0','docx'),(2,1,'Open-Office Text document',23,'PK\0\0\0\0\0K;\Z9^∆2\'\0\0\0\'\0\0\0\0\0\0mimetypeapplication/vnd.oasis.opendocument.textPK\0\0\0\0\0K;\Z9\0\0\0\0\0\0\0\0\0\0\0\0\Z\0\0\0Configurations2/statusbar/PK\0\0\0K;\Z9\0\0\0\0\0\0\0\0\0\0\0\0\'\0\0\0Configurations2/accelerator/current.xml\0PK\0\0\0\0\0\0\0\0\0\0\0PK\0\0\0\0\0K;\Z9\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0Configurations2/floater/PK\0\0\0\0\0K;\Z9\0\0\0\0\0\0\0\0\0\0\0\0\Z\0\0\0Configurations2/popupmenu/PK\0\0\0\0\0K;\Z9\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0Configurations2/progressbar/PK\0\0\0\0\0K;\Z9\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0Configurations2/menubar/PK\0\0\0\0\0K;\Z9\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0Configurations2/toolbar/PK\0\0\0\0\0K;\Z9\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0Configurations2/images/Bitmaps/PK\0\0\0K;\Z9\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0content.xml•VÀn!›˜+F,∫c\']$Sè£JQ•JIMZuKÄ±iyLÅÒÿ_û1N2	í7∂πúsπús/ovÇ[™\rS≤ãŸTbEò\\◊‡Á„◊Ú\n‹¨>,U”0L+¢p\'®¥%V“∫Ô¬±•©‚l\r:-+Ö3ïDÇö ‚JµT¨*EWa≠1vœ≥Èú≤-›Ÿ\\≤«ûp—S˛ ú≤âF}.Ÿcù®)ΩQπ‰ù·e£úÍ¢Eñ=´b«ô¸[Éçµmaﬂ˜≥˛r¶Ù\Z.ÆØØaò∆#ÆÌ4(Ç!Â‘/f‡b∂ÄVPãrÎÛÿ¥$Ÿâ\'™≥•AΩp’l◊Ÿ±]OHÉ7Hg˜F\0ü⁄{IÚÌΩ$)W ªô‰\nﬁª…qwÏ-r◊Úÿ©∞fmˆ6#:Â+•∆R=!–PÓ≈|˛	∆qÇÓﬂÑ˜öY™8~é«£‚Jº&ö√-†CîtÎ€tl|/Ñô \\¿8=Ç\rôL˝˚˛Óo®@G0{\\2i,íGe\ZF˘–0„F^–]K5Û6 Ó4ÒõQ§q)úT™≠í—ô9πô`5\\√—B«@„Æ„≤AòñÑbnVÀxú∆p«æî\Z<∫2LÒùˆ≈%êÖ;?T0æØ¡G‘*Û˘.Aqí⁄„À5ïnoŒe}»wD¥Ãbw∂H3y¯vi_åøR–ü^⁄ÙÃòsñæ•–ØÆx@“L*í`2‘0{c©xØ&8e·!é:ÎTµó!Ob˙ì\"˚q‡∂’2<oÜ˛Î‹>&z,Bà0”r¥/Ug›AKÓNØÅkæ0e˘∆yg¨v(ÈÀ=+Ÿ„∞ÈÛ≤∏üg\'πçœqp`Zµ6RÇÚe$>∏#Oê&©wQ|x‚ú¯À¥˙PK’\0=@ê\0\0s	\0\0PK\0\0\0K;\Z9\0\0\0\0\0\0\0\0\0\0\0\0\n\0\0\0styles.xmlÕYKè€6æ˜W*⁄mÀªõÆ›ÏEã¢íö¥◊Äñhã	E\n$eŸ˘ıí¢DÀíW˚H·=, ŒpÊ„<…ÒÎ7˚úMvD**¯]OÁ—ÑD§îoÔ¢?˛ân£7˜?ºõ\rM»*IôÆë“F‘6sµrƒª®î|%∞¢j≈qN‘J\'+QÓ7≠BÓïUÂV¨∞±€-s∏[ìΩªŸÌ≈ÎÒö-s∏;ï∏\ZªŸÇM√Ì1vÛ^1¥(yÅ5Ì†ÿ3 ø‹Eô÷≈j6´™jZ]MÖ‹Œ‚Âr9≥‘p“•dñ+MfÑ£LÕ‚i<Ûº9—x,>√B‚eæ&r¥i∞∆\'^UªÌËàÿmLìdXéé\rÀ|Ïﬁ´tº{Ø“poéu6‡ì€Ÿ; ⁄Ôﬁ∂± Û±∫Ôë©Iã—«t‹·~!D’lp	j·.ÊÛÎô˚∏´≥Ïï§ö»Ä=9Àû`ñ4yü—Ä/û\";¶—§.!AŸä£{_£6Í”\'•$aÍ˛µã≠fy‚æççÓ¢è,5yO™…?\"«<ö@0y÷ú≤√]Ù3.Ñ˙µ√Á£…ëh√è∂ÑI·»≤ñ◊rT\';,©©$—Ï<¥ﬂÄçı\0ÚÎ√™UEïzéÍ?»g¸_9˘Äπ\Z¥H¿3¬\ZÍ†4…¬4raΩÓ∫é«ûí\r.Y›ãº‰\Z„V‚\"£I‰yÎoTHàA©)8”T‰ï p**Ú—hÕßW	‡Ï!:D\rÂAu%H8Å⁄é2!ÈWÄéôa]‹ûeﬁ…)+$ÏX©\'¨=2k≥08GEuÜ\\∑‹`¶Ç((∞ƒ÷B°}…#\\jat@h–î«äYëaØ¿¬XKÇ°)\r.◊ûb Å¡ñã∂3âÙ˙((Oâ©RÊV∆ÉÙ°˚ÇßE°Lú√nÿ\rÓì”îäÄ∏Ò™Uû&†OiYB}€áH—ØÄ4^⁄Æ1Ã∑%ﬁ¬gv!%◊¬·˝€Ê¯DCÕC_à‰∫ú“»DPõ±©VÛÈM—ÿ«ã˜‘Ø˚Ω\'’ä<Öﬁ#‘t>FˆpGhCÌ€–¨‡÷¨Gy5&Ÿ\Z?Dg\nLóäåph‘Ç#Ü”lf—‡˝ú6\'wE…]:Åê°}¿—¡¶(îRHOnîƒ”≈M‹fÕqË`œ6eû_ÅÁöœ˜å@£“G“q}ˇŒQj7±vVıK≈rjƒín¸Iíc ëπˆ˘ \\ú0• :,œH˚Ç+\Z#aπ∆ZHì&Ë†êC1\\(—œUå§®: a•ì°_)ê[¢3sÉ7¯ê‚P°ÏêO)ñi4X(º˚V\n‡A2µ©u*Ô/Ç” ß≈¡BÛ8E˝P∏…€ê·#,|ZÃ?≠EzËÉıPIÀ±Ñz&+L◊Ω^ÿÆ€ÆØÖ÷ÊV\r9^‘$kc€çπÌ∆òU¯†™-A·®ØÄùrq›ÊÃ”2æW¿c3◊iÊÅ@È3>î„Ç·C‡ûIH~éÛüÏ◊Û>}‹∑–iûré31 å»Ås‰Ë≈c|Ù;.L)|A˚JâôXmˆ%ñùÌ∏…ÉΩH™¶[äΩ¯¡ƒ|8Ÿz∞[sÉ*\nwqx[ú5Ô—ö§¶mÓÌ}¡ˆÜ^Ìøø·nΩAÔQ+Ô¨˜^»è\n_+Yî⁄Ω!z÷ŸVwG√,Ä∏¶5î92≥%π9ü…Øzk˜Ä95óÿ5P⁄$ºo„∫$iâkq°∏Æ.◊ıÖ‚∫πP\\Ø.◊/äÎˆBq-/W<ˇˇÅìB¥\\h¢†âÚ\r›ñ“>Ó&\r’≠m#Ñ6ﬂ}¿„∫yπQﬁ≥“†™˝FÖ\n°®∂Ci;/˜∏ég\nFûÀõçGHx:êˆÙ‚çEZ}j˚µÄ⁄ÁÕrŸéG˙¨Si≠¿»F◊4 ih251òˆZiÌê◊<9A&Mê\'¯õ∆ºç‡›£˚Më«QOÁNg)MÕœ2ã˘tÈ‚	°€ÃºÓó”WgéX+j$$Ö£‡⁄◊B¬ïñÍ®{q∏¥vñçëNe\rih’•∫\0D9ﬁ7ß1œñv–_3(RxqŒ\ZÛÈ<æmï¯îCk\'∑¸Ü\'û«=<xcÜN},8˝\\*ÌºÌb¿≠KHVÔÜõü⁄1éùì˝8∑Q8‚Ìs®?TF∞ïÿèYx“`ÒTPyß°Vr¨\Zç∂z—H:;Ì1∑!\Z|G˙¨ˇ«ı˚oPKÍÑE—}\0\0ú\0\0PK\0\0\0\0\0K;\Z9ëgä≤\0\0\0\0\0\0\0meta.xml<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<office:document-meta xmlns:office=\"urn:oasis:names:tc:opendocument:xmlns:office:1.0\" xmlns:xlink=\"http://www.w3.org/1999/xlink\" xmlns:dc=\"http://purl.org/dc/elements/1.1/\" xmlns:meta=\"urn:oasis:names:tc:opendocument:xmlns:meta:1.0\" xmlns:ooo=\"http://openoffice.org/2004/office\" office:version=\"1.1\"><office:meta><meta:generator>OpenOffice.org/2.4$Linux OpenOffice.org_project/680m17$Build-9310</meta:generator><meta:initial-creator>Merijn Schering</meta:initial-creator><meta:creation-date>2008-08-26T09:26:02</meta:creation-date><meta:editing-cycles>0</meta:editing-cycles><meta:editing-duration>PT0S</meta:editing-duration><meta:user-defined meta:name=\"Info 1\"/><meta:user-defined meta:name=\"Info 2\"/><meta:user-defined meta:name=\"Info 3\"/><meta:user-defined meta:name=\"Info 4\"/><meta:document-statistic meta:table-count=\"0\" meta:image-count=\"0\" meta:object-count=\"0\" meta:page-count=\"1\" meta:paragraph-count=\"0\" meta:word-count=\"0\" meta:character-count=\"0\"/></office:meta></office:document-meta>PK\0\0\0K;\Z9\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0Thumbnails/thumbnail.pngÎsÁÂí‚b``‡ıÙp	“[8ÿÄ¨Ø Ê∑òˆ{∫8ÜTÃy{i#\'ÉœÅ\r|?ˇ?˝“Èt–Cº‚√õwçì~ 2¨ü9K&xrrVëèoﬂ ìÜ¶ñÀ‘é_y2cTpTp¿≈œÂ≤˝3\nˇ*L—ûÆ~.Îúö\0PKÑ◊É£|\0\0\0¯\0\0PK\0\0\0K;\Z9\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0settings.xmlµYQs‚8~ø_—…;JoÔ ¥Ï∫Ï±•Ö∫ù€7ì»’±2∂S‡ﬂüÏÑN°K	~¢Ml…í•ÔìîÎØ´òüΩÄTäØ~^ÛŒ@Fb~„=N∫ïøΩØ≠?Æq6ãhÜ§1]Q†5-Qg¥]®fˆ˙∆K•h\"Sëj\nÉjÍ†â	àÕ∂Ê€’M´,{≤‚ëxæÒZ\'Õjuπ\\û/Á(Á’˙’’U’æ›,\rPÃ¢˘°™≤’oU!‚´\"≥!;åUvQ´]V≥ˇΩ≥¸êo\\S˜Z?lÃo]Á\n≤üJ§!6æ9Àõ£›x§≤˘¡Ú’k^—æ˜{~“z_õ`‚mﬁËuBo\"°ΩVÌ∫∫+·p©}òÈ\"±ïz≠^˚´úÏß(‘ã\"·óçã∆üÂdˇ—|QxÚãz˝ÍH·„.GRêAg¡ƒ‘ñÇ)\"&ºññ)ß£\'⁄ó\nÓ1Ñ}“gå´É≈WbñT\"¬\n¬]_Gò›Cπ!◊áyºnUiI·ÎµL0_ì˚¢ØQ´ïê∫\'S U—îÉõ\\±¢Où‹VËh_ä4\Zıã/•D∑Qkå˜•_„8Ÿø„	I⁄éµ „}aÑvY†Qã≠◊é‹Sc‡hªíëÀﬂ&Êæ◊yÆ/ b9úä≤©döàÌ3ú‰á·êI6a\n„ÑNéîCÇ=√ª∞ç?«AÂ{˘ÉT§Ôì˛o<Ti<˘Å1%¥ı©ryLB¶ãêã%ı-NÙz»‹p÷\\†Ñn$ï&3†G(tO∏tÒØ§¨Ÿ¡8ë†LÈurl∞éì~‡tØ„Jòë›xW∞Aúp˙€QûY“ËÉN∑π‰ñP [úÃf.|eÌ0Î(äÛ n(QlS<›¡z[SÂ≤	&◊^ı¿#[tpﬁ¸†]î€D{™”~™1QGaŸA‚2‰NºC‚AÜ˚\'o1É7∫FÂã∞ÕôxV‰tÉt∆Éî[ztæ®≠Ü˝ºp$ºıëÖ#`!\næËßAS‰¸?Aõ‡.nõt}[—u∆˚dëìz√Oæ~T oôfßﬂ5%ÜÀÑ≥¯ô\r)¢√Qù¶ø‹UÚù„îÒ€|æb\nt–Swtﬂæäò¶\"–©´4Ùy4ºcç…UÙëö„oß√£ƒWØeç/ mü$-ï]æ∂‰Í¬èùTJ∫&‘ÕÔSÏ`M÷“Äó∑¯Ä∫√ùJ∏ïl9ò˛ß¬∞∂É„[T·Ú¿EYì”»√nw∏?¨å.[ïBL©¢‰V˙I≤d »≠é.äRÊñﬂ1pVœŸÑ´∂DıŸ^Å»çßL˘∂¯M£[ûIﬂ∂”æk*–NÔ¥Wì6Åñ∏±…Çƒ®W0¶˘ZKSTQÀÿE\'WïuAUB5≥+˘ﬂ…_ã≤•DÒ¡9.≠ÍD;L¿p–{*†÷:f\",h´ÀÌ≈ˇHïéfkì6Í)“ã{&R∆€ÿ≥éP#0u˙L0O8Ãfä±M©‡&}rt6∂òoY¶ŒbkL∑Õ⁄Ã·≥	\nyjŒTÜ\\NuÚQ≈⁄,xûKL≈ﬁ¡ﬁ©£ºªõ2«ŒF›Ù±‘tœù–ΩXQ‹$Rıõ˛ÈìÛj;oÆÓ|≠Ó˚L‹˙PKtëá€\0\0h\0\0PK\0\0\0K;\Z9\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0META-INF/manifest.xmlµïKj√0@˜=Ö—ﬁV€U1q-ÙÈ&ÚÿËáfí€W‰”6î¶X;	§˜F#Õh±⁄[SÌ0íˆÆOÕ£®–)ﬂk7v‚c˝^øà’Úaa¡Èâ€”† ˚ùßùH—µHSÎ¿\"µ¨Z–ı^%ãé€ØÎ€…¥|®.‡A¨Û¬x®.2Ï5‘|ÿ	¡hú„î;◊7GWs≠h˜,.ªádLÄ∑ùêBﬁ%ªMyÛn–cä« ËY\'⁄@,É•–`û˙(Uäq:bŒbqW¡`<0ÇR»O ¬G?F§r7=Ö^ŒﬁõbpmaDíØö-*Í∏ì˝Ω_PrSı4I7ÍZ∑ÓîOùHNµzû˝¸øb˛ùK|0H≥c-2Ã÷x÷€d7¥!…ßa‹87|ﬁƒ\"s˛œ©]»ˇ·ÚPK5b◊9>\0\0J\0\0PK\0\0\0\0\0\0K;\Z9^∆2\'\0\0\0\'\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0mimetypePK\0\0\0\0\0\0K;\Z9\0\0\0\0\0\0\0\0\0\0\0\0\Z\0\0\0\0\0\0\0\0\0\0\0\0\0M\0\0\0Configurations2/statusbar/PK\0\0\0\0K;\Z9\0\0\0\0\0\0\0\0\0\0\0\'\0\0\0\0\0\0\0\0\0\0\0\0\0Ö\0\0\0Configurations2/accelerator/current.xmlPK\0\0\0\0\0\0K;\Z9\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0‹\0\0\0Configurations2/floater/PK\0\0\0\0\0\0K;\Z9\0\0\0\0\0\0\0\0\0\0\0\0\Z\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0Configurations2/popupmenu/PK\0\0\0\0\0\0K;\Z9\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0J\0\0Configurations2/progressbar/PK\0\0\0\0\0\0K;\Z9\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0Ñ\0\0Configurations2/menubar/PK\0\0\0\0\0\0K;\Z9\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0∫\0\0Configurations2/toolbar/PK\0\0\0\0\0\0K;\Z9\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0Configurations2/images/Bitmaps/PK\0\0\0\0K;\Z9’\0=@ê\0\0s	\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0-\0\0content.xmlPK\0\0\0\0K;\Z9ÍÑE—}\0\0ú\0\0\n\0\0\0\0\0\0\0\0\0\0\0\0\0ˆ\0\0styles.xmlPK\0\0\0\0\0\0K;\Z9ëgä≤\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0´\0\0meta.xmlPK\0\0\0\0K;\Z9Ñ◊É£|\0\0\0¯\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ﬂ\0\0Thumbnails/thumbnail.pngPK\0\0\0\0K;\Z9tëá€\0\0h\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0°\0\0settings.xmlPK\0\0\0\0K;\Z95b◊9>\0\0J\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0∂\0\0META-INF/manifest.xmlPK\0\0\0\0\0\0Ó\0\07\0\0\0\0','odt');
/*!40000 ALTER TABLE `fs_templates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fs_versions`
--

DROP TABLE IF EXISTS `fs_versions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fs_versions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `file_id` int(11) NOT NULL,
  `mtime` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `path` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `version` int(11) NOT NULL DEFAULT 1,
  `size_bytes` bigint(20) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `file_id` (`file_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fs_versions`
--

LOCK TABLES `fs_versions` WRITE;
/*!40000 ALTER TABLE `fs_versions` DISABLE KEYS */;
/*!40000 ALTER TABLE `fs_versions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `go_address_format`
--

DROP TABLE IF EXISTS `go_address_format`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `go_address_format` (
  `id` int(11) NOT NULL,
  `format` text COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `go_address_format`
--

LOCK TABLES `go_address_format` WRITE;
/*!40000 ALTER TABLE `go_address_format` DISABLE KEYS */;
/*!40000 ALTER TABLE `go_address_format` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `go_advanced_searches`
--

DROP TABLE IF EXISTS `go_advanced_searches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `go_advanced_searches` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `user_id` int(11) NOT NULL DEFAULT 0,
  `acl_id` int(11) NOT NULL DEFAULT 0,
  `data` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `model_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `go_advanced_searches`
--

LOCK TABLES `go_advanced_searches` WRITE;
/*!40000 ALTER TABLE `go_advanced_searches` DISABLE KEYS */;
/*!40000 ALTER TABLE `go_advanced_searches` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `go_cache`
--

DROP TABLE IF EXISTS `go_cache`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `go_cache` (
  `user_id` int(11) NOT NULL,
  `key` varchar(190) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `content` longtext COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `mtime` int(11) NOT NULL,
  PRIMARY KEY (`user_id`,`key`),
  KEY `mtime` (`mtime`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `go_cache`
--

LOCK TABLES `go_cache` WRITE;
/*!40000 ALTER TABLE `go_cache` DISABLE KEYS */;
/*!40000 ALTER TABLE `go_cache` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `go_cf_setting_tabs`
--

DROP TABLE IF EXISTS `go_cf_setting_tabs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `go_cf_setting_tabs` (
  `cf_category_id` int(11) NOT NULL,
  PRIMARY KEY (`cf_category_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `go_cf_setting_tabs`
--

LOCK TABLES `go_cf_setting_tabs` WRITE;
/*!40000 ALTER TABLE `go_cf_setting_tabs` DISABLE KEYS */;
/*!40000 ALTER TABLE `go_cf_setting_tabs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `go_clients`
--

DROP TABLE IF EXISTS `go_clients`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `go_clients` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `footprint` varchar(190) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` int(11) NOT NULL,
  `ip` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_agent` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ctime` int(11) NOT NULL,
  `last_active` int(11) NOT NULL,
  `in_use` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_footprint` (`footprint`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `go_clients`
--

LOCK TABLES `go_clients` WRITE;
/*!40000 ALTER TABLE `go_clients` DISABLE KEYS */;
/*!40000 ALTER TABLE `go_clients` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `go_countries`
--

DROP TABLE IF EXISTS `go_countries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `go_countries` (
  `id` int(11) NOT NULL DEFAULT 0,
  `name` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `iso_code_2` char(2) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `iso_code_3` char(3) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `go_countries`
--

LOCK TABLES `go_countries` WRITE;
/*!40000 ALTER TABLE `go_countries` DISABLE KEYS */;
/*!40000 ALTER TABLE `go_countries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `go_cron`
--

DROP TABLE IF EXISTS `go_cron`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `go_cron` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT 1,
  `minutes` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '1',
  `hours` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '1',
  `monthdays` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '*',
  `months` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '*',
  `weekdays` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '*',
  `years` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '*',
  `job` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `runonce` tinyint(1) NOT NULL DEFAULT 0,
  `nextrun` int(11) NOT NULL DEFAULT 0,
  `lastrun` int(11) NOT NULL DEFAULT 0,
  `completedat` int(11) NOT NULL DEFAULT 0,
  `error` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `autodestroy` tinyint(1) NOT NULL DEFAULT 0,
  `params` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `nextrun_active` (`nextrun`,`active`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `go_cron`
--

LOCK TABLES `go_cron` WRITE;
/*!40000 ALTER TABLE `go_cron` DISABLE KEYS */;
INSERT INTO `go_cron` VALUES (1,'Calendar publisher',1,'0','*','*','*','*','*','GO\\Calendar\\Cron\\CalendarPublisher',0,1595674800,0,0,NULL,0,'[]'),(2,'Email Reminders',1,'*/5','*','*','*','*','*','GO\\Base\\Cron\\EmailReminders',0,1595674500,0,0,NULL,0,'[]'),(3,'Calculate disk usage',1,'0','0','*','*','*','*','GO\\Base\\Cron\\CalculateDiskUsage',0,1595721600,0,0,NULL,0,'[]');
/*!40000 ALTER TABLE `go_cron` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `go_cron_groups`
--

DROP TABLE IF EXISTS `go_cron_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `go_cron_groups` (
  `cronjob_id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL,
  PRIMARY KEY (`cronjob_id`,`group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `go_cron_groups`
--

LOCK TABLES `go_cron_groups` WRITE;
/*!40000 ALTER TABLE `go_cron_groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `go_cron_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `go_cron_users`
--

DROP TABLE IF EXISTS `go_cron_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `go_cron_users` (
  `cronjob_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`cronjob_id`,`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `go_cron_users`
--

LOCK TABLES `go_cron_users` WRITE;
/*!40000 ALTER TABLE `go_cron_users` DISABLE KEYS */;
/*!40000 ALTER TABLE `go_cron_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `go_holidays`
--

DROP TABLE IF EXISTS `go_holidays`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `go_holidays` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` date NOT NULL,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `region` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `free_day` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  KEY `region` (`region`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `go_holidays`
--

LOCK TABLES `go_holidays` WRITE;
/*!40000 ALTER TABLE `go_holidays` DISABLE KEYS */;
/*!40000 ALTER TABLE `go_holidays` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `go_links_em_links`
--

DROP TABLE IF EXISTS `go_links_em_links`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `go_links_em_links` (
  `id` int(11) NOT NULL,
  `folder_id` int(11) NOT NULL,
  `model_id` int(11) NOT NULL,
  `model_type_id` int(11) NOT NULL,
  `description` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ctime` int(11) NOT NULL,
  PRIMARY KEY (`id`,`model_id`,`model_type_id`),
  KEY `id` (`id`,`folder_id`),
  KEY `ctime` (`ctime`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `go_links_em_links`
--

LOCK TABLES `go_links_em_links` WRITE;
/*!40000 ALTER TABLE `go_links_em_links` DISABLE KEYS */;
/*!40000 ALTER TABLE `go_links_em_links` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `go_links_fs_files`
--

DROP TABLE IF EXISTS `go_links_fs_files`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `go_links_fs_files` (
  `id` int(11) NOT NULL,
  `folder_id` int(11) NOT NULL,
  `model_id` int(11) NOT NULL,
  `model_type_id` int(11) NOT NULL,
  `description` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ctime` int(11) NOT NULL,
  PRIMARY KEY (`id`,`model_id`,`model_type_id`),
  KEY `id` (`id`,`folder_id`),
  KEY `ctime` (`ctime`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `go_links_fs_files`
--

LOCK TABLES `go_links_fs_files` WRITE;
/*!40000 ALTER TABLE `go_links_fs_files` DISABLE KEYS */;
/*!40000 ALTER TABLE `go_links_fs_files` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `go_links_fs_folders`
--

DROP TABLE IF EXISTS `go_links_fs_folders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `go_links_fs_folders` (
  `id` int(11) NOT NULL,
  `folder_id` int(11) NOT NULL,
  `model_id` int(11) NOT NULL,
  `model_type_id` int(11) NOT NULL,
  `description` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ctime` int(11) NOT NULL,
  PRIMARY KEY (`id`,`model_id`,`model_type_id`),
  KEY `id` (`id`,`folder_id`),
  KEY `ctime` (`ctime`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `go_links_fs_folders`
--

LOCK TABLES `go_links_fs_folders` WRITE;
/*!40000 ALTER TABLE `go_links_fs_folders` DISABLE KEYS */;
/*!40000 ALTER TABLE `go_links_fs_folders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `go_links_ta_tasks`
--

DROP TABLE IF EXISTS `go_links_ta_tasks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `go_links_ta_tasks` (
  `id` int(11) NOT NULL,
  `folder_id` int(11) NOT NULL,
  `model_id` int(11) NOT NULL,
  `model_type_id` int(11) NOT NULL,
  `description` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ctime` int(11) NOT NULL,
  PRIMARY KEY (`id`,`model_id`,`model_type_id`),
  KEY `id` (`id`,`folder_id`),
  KEY `ctime` (`ctime`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `go_links_ta_tasks`
--

LOCK TABLES `go_links_ta_tasks` WRITE;
/*!40000 ALTER TABLE `go_links_ta_tasks` DISABLE KEYS */;
/*!40000 ALTER TABLE `go_links_ta_tasks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `go_log`
--

DROP TABLE IF EXISTS `go_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `go_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `username` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `model` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `model_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `ctime` int(11) NOT NULL,
  `user_agent` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `ip` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `controller_route` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `action` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `message` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `jsonData` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `go_log`
--

LOCK TABLES `go_log` WRITE;
/*!40000 ALTER TABLE `go_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `go_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `go_reminders`
--

DROP TABLE IF EXISTS `go_reminders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `go_reminders` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `model_id` int(11) NOT NULL,
  `model_type_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `time` int(11) NOT NULL,
  `vtime` int(11) NOT NULL DEFAULT 0,
  `snooze_time` int(11) NOT NULL,
  `manual` tinyint(1) NOT NULL DEFAULT 0,
  `text` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `go_reminders`
--

LOCK TABLES `go_reminders` WRITE;
/*!40000 ALTER TABLE `go_reminders` DISABLE KEYS */;
/*!40000 ALTER TABLE `go_reminders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `go_reminders_users`
--

DROP TABLE IF EXISTS `go_reminders_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `go_reminders_users` (
  `reminder_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `time` int(11) NOT NULL,
  `mail_sent` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`reminder_id`,`user_id`),
  KEY `user_id_time` (`user_id`,`time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `go_reminders_users`
--

LOCK TABLES `go_reminders_users` WRITE;
/*!40000 ALTER TABLE `go_reminders_users` DISABLE KEYS */;
/*!40000 ALTER TABLE `go_reminders_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `go_saved_exports`
--

DROP TABLE IF EXISTS `go_saved_exports`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `go_saved_exports` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `class_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `view` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `export_columns` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `orientation` enum('V','H') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'V',
  `include_column_names` tinyint(1) NOT NULL DEFAULT 1,
  `use_db_column_names` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `go_saved_exports`
--

LOCK TABLES `go_saved_exports` WRITE;
/*!40000 ALTER TABLE `go_saved_exports` DISABLE KEYS */;
/*!40000 ALTER TABLE `go_saved_exports` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `go_saved_search_queries`
--

DROP TABLE IF EXISTS `go_saved_search_queries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `go_saved_search_queries` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `sql` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `type` (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `go_saved_search_queries`
--

LOCK TABLES `go_saved_search_queries` WRITE;
/*!40000 ALTER TABLE `go_saved_search_queries` DISABLE KEYS */;
/*!40000 ALTER TABLE `go_saved_search_queries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `go_search_sync`
--

DROP TABLE IF EXISTS `go_search_sync`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `go_search_sync` (
  `user_id` int(11) NOT NULL DEFAULT 0,
  `module` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `last_sync_time` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`user_id`,`module`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `go_search_sync`
--

LOCK TABLES `go_search_sync` WRITE;
/*!40000 ALTER TABLE `go_search_sync` DISABLE KEYS */;
/*!40000 ALTER TABLE `go_search_sync` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `go_settings`
--

DROP TABLE IF EXISTS `go_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `go_settings` (
  `user_id` int(11) NOT NULL DEFAULT 0,
  `name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `value` longtext COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`user_id`,`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `go_settings`
--

LOCK TABLES `go_settings` WRITE;
/*!40000 ALTER TABLE `go_settings` DISABLE KEYS */;
INSERT INTO `go_settings` VALUES (0,'zpushadmin_can_connect','1'),(1,'email_always_request_notification','0'),(1,'email_always_respond_to_notifications','0'),(1,'email_defaultTemplateId',NULL),(1,'email_font_size','14px'),(1,'email_show_bcc','0'),(1,'email_show_cc','1'),(1,'email_show_from','1'),(1,'email_skip_unknown_recipients','0'),(1,'email_sort_email_addresses_by_time','1'),(1,'email_use_plain_text_markup','0');
/*!40000 ALTER TABLE `go_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `go_state`
--

DROP TABLE IF EXISTS `go_state`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `go_state` (
  `user_id` int(11) NOT NULL,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `value` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`user_id`,`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `go_state`
--

LOCK TABLES `go_state` WRITE;
/*!40000 ALTER TABLE `go_state` DISABLE KEYS */;
INSERT INTO `go_state` VALUES (1,'su-tasks-grid','o%3Acolumns%3Da%253Ao%25253Aid%25253Dn%2525253A0%25255Ewidth%25253Dn%2525253A40%255Eo%25253Aid%25253Ds%2525253Atask-portlet-name-col%25255Ewidth%25253Dn%2525253A531%255Eo%25253Aid%25253Dn%2525253A2%25255Ewidth%25253Dn%2525253A100%255Eo%25253Aid%25253Dn%2525253A3%25255Ewidth%25253Dn%2525253A150%25255Ehidden%25253Db%2525253A1%255Eo%25253Aid%25253Dn%2525253A4%25255Ewidth%25253Dn%2525253A50%25255Ehidden%25253Db%2525253A1%5Esort%3Do%253Afield%253Ds%25253Adue_time%255Edirection%253Ds%25253AASC%5Egroup%3Ds%253Atasklist_name');
/*!40000 ALTER TABLE `go_state` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `go_templates`
--

DROP TABLE IF EXISTS `go_templates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `go_templates` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT 0,
  `type` tinyint(4) NOT NULL DEFAULT 0,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `acl_id` int(11) NOT NULL DEFAULT 0,
  `content` longblob NOT NULL,
  `extension` varchar(4) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `go_templates`
--

LOCK TABLES `go_templates` WRITE;
/*!40000 ALTER TABLE `go_templates` DISABLE KEYS */;
INSERT INTO `go_templates` VALUES (1,1,0,'Default',8,'Message-ID: <c474869bd9b6713be9e93bbb70ce99c5@powermail.mydomainname.com>\r\nDate: Sat, 25 Jul 2020 10:50:43 +0000\r\nFrom: \r\nMIME-Version: 1.0\r\nContent-Type: multipart/alternative;\r\n boundary=\"_=_swift_1595674243_16e98ff2db13dd5e74fe87c3c9d81101_=_\"\r\nX-Group-Office-Title: Group-Office\r\n\r\n\r\n--_=_swift_1595674243_16e98ff2db13dd5e74fe87c3c9d81101_=_\r\nContent-Type: text/plain; charset=UTF-8\r\nContent-Transfer-Encoding: quoted-printable\r\n\r\nHi {contact:firstName},\r\n\r\n{body}\r\n\r\nBest regards\r\n\r\n\r\n{user:displayName}\r\n\r\n--_=_swift_1595674243_16e98ff2db13dd5e74fe87c3c9d81101_=_\r\nContent-Type: text/html; charset=UTF-8\r\nContent-Transfer-Encoding: quoted-printable\r\n\r\nHi<gotpl if=3D\"contact:firstName\"> {contact:firstName},</gotpl><br />\r\n<br />\r\n{body}<br />\r\n<br />\r\nBest regards<br />\r\n<br />\r\n<br />\r\n{user:displayName}<br />\r\n\r\n--_=_swift_1595674243_16e98ff2db13dd5e74fe87c3c9d81101_=_--\r\n','');
/*!40000 ALTER TABLE `go_templates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `go_working_weeks`
--

DROP TABLE IF EXISTS `go_working_weeks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `go_working_weeks` (
  `user_id` int(11) NOT NULL DEFAULT 0,
  `mo_work_hours` double NOT NULL DEFAULT 8,
  `tu_work_hours` double NOT NULL DEFAULT 8,
  `we_work_hours` double NOT NULL DEFAULT 8,
  `th_work_hours` double NOT NULL DEFAULT 8,
  `fr_work_hours` double NOT NULL DEFAULT 8,
  `sa_work_hours` double NOT NULL DEFAULT 0,
  `su_work_hours` double NOT NULL DEFAULT 0,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `go_working_weeks`
--

LOCK TABLES `go_working_weeks` WRITE;
/*!40000 ALTER TABLE `go_working_weeks` DISABLE KEYS */;
/*!40000 ALTER TABLE `go_working_weeks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `googleauth_secret`
--

DROP TABLE IF EXISTS `googleauth_secret`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `googleauth_secret` (
  `userId` int(11) NOT NULL,
  `secret` varchar(16) COLLATE utf8mb4_unicode_ci NOT NULL,
  `createdAt` datetime NOT NULL,
  PRIMARY KEY (`userId`),
  KEY `user` (`userId`),
  CONSTRAINT `googleauth_secret_user` FOREIGN KEY (`userId`) REFERENCES `core_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `googleauth_secret`
--

LOCK TABLES `googleauth_secret` WRITE;
/*!40000 ALTER TABLE `googleauth_secret` DISABLE KEYS */;
/*!40000 ALTER TABLE `googleauth_secret` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `imapauth_server`
--

DROP TABLE IF EXISTS `imapauth_server`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `imapauth_server` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `imapHostname` varchar(190) COLLATE utf8mb4_unicode_ci NOT NULL,
  `imapPort` int(11) NOT NULL DEFAULT 143,
  `imapEncryption` enum('tls','ssl') COLLATE utf8mb4_unicode_ci DEFAULT 'tls',
  `imapValidateCertificate` tinyint(1) NOT NULL DEFAULT 1,
  `removeDomainFromUsername` tinyint(1) NOT NULL DEFAULT 0,
  `smtpHostname` varchar(190) COLLATE utf8mb4_unicode_ci NOT NULL,
  `smtpPort` int(11) NOT NULL DEFAULT 587,
  `smtpUsername` varchar(190) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `smtpPassword` varchar(512) CHARACTER SET ascii COLLATE ascii_bin DEFAULT NULL,
  `smtpUseUserCredentials` tinyint(1) NOT NULL DEFAULT 0,
  `smtpEncryption` enum('tls','ssl') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `smtpValidateCertificate` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `imapauth_server`
--

LOCK TABLES `imapauth_server` WRITE;
/*!40000 ALTER TABLE `imapauth_server` DISABLE KEYS */;
INSERT INTO `imapauth_server` VALUES (3,'127.0.0.1',143,NULL,0,0,'127.0.0.1',587,NULL,NULL,1,NULL,0);
/*!40000 ALTER TABLE `imapauth_server` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `imapauth_server_domain`
--

DROP TABLE IF EXISTS `imapauth_server_domain`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `imapauth_server_domain` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `serverId` int(11) NOT NULL,
  `name` varchar(190) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `serverId` (`serverId`),
  CONSTRAINT `imapauth_server_domain_ibfk_1` FOREIGN KEY (`serverId`) REFERENCES `imapauth_server` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `imapauth_server_domain`
--

LOCK TABLES `imapauth_server_domain` WRITE;
/*!40000 ALTER TABLE `imapauth_server_domain` DISABLE KEYS */;
INSERT INTO `imapauth_server_domain` VALUES (3,3,'powermail.mydomainname.com');
/*!40000 ALTER TABLE `imapauth_server_domain` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `imapauth_server_group`
--

DROP TABLE IF EXISTS `imapauth_server_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `imapauth_server_group` (
  `serverId` int(11) NOT NULL,
  `groupId` int(11) NOT NULL,
  PRIMARY KEY (`serverId`,`groupId`),
  KEY `groupId` (`groupId`),
  CONSTRAINT `imapauth_server_group_ibfk_1` FOREIGN KEY (`serverId`) REFERENCES `imapauth_server` (`id`) ON DELETE CASCADE,
  CONSTRAINT `imapauth_server_group_ibfk_2` FOREIGN KEY (`groupId`) REFERENCES `core_group` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `imapauth_server_group`
--

LOCK TABLES `imapauth_server_group` WRITE;
/*!40000 ALTER TABLE `imapauth_server_group` DISABLE KEYS */;
INSERT INTO `imapauth_server_group` VALUES (3,3);
/*!40000 ALTER TABLE `imapauth_server_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notes_note`
--

DROP TABLE IF EXISTS `notes_note`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `notes_note` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `noteBookId` int(11) NOT NULL,
  `createdBy` int(11) NOT NULL,
  `modifiedBy` int(11) NOT NULL,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `content` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `filesFolderId` int(11) DEFAULT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `createdAt` datetime DEFAULT NULL,
  `modifiedAt` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`createdBy`),
  KEY `category_id` (`noteBookId`),
  CONSTRAINT `notes_note_ibfk_1` FOREIGN KEY (`noteBookId`) REFERENCES `notes_note_book` (`id`) ON DELETE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=173 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notes_note`
--

LOCK TABLES `notes_note` WRITE;
/*!40000 ALTER TABLE `notes_note` DISABLE KEYS */;
/*!40000 ALTER TABLE `notes_note` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notes_note_book`
--

DROP TABLE IF EXISTS `notes_note_book`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `notes_note_book` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `deletedAt` datetime DEFAULT NULL,
  `createdBy` int(11) NOT NULL,
  `aclId` int(11) NOT NULL,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `filesFolderId` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `aclId` (`aclId`),
  CONSTRAINT `notes_note_book_ibfk_1` FOREIGN KEY (`aclId`) REFERENCES `core_acl` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=66 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notes_note_book`
--

LOCK TABLES `notes_note_book` WRITE;
/*!40000 ALTER TABLE `notes_note_book` DISABLE KEYS */;
INSERT INTO `notes_note_book` VALUES (65,NULL,1,12,'Shared',NULL);
/*!40000 ALTER TABLE `notes_note_book` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notes_note_custom_fields`
--

DROP TABLE IF EXISTS `notes_note_custom_fields`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `notes_note_custom_fields` (
  `id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `notes_note_custom_fields_ibfk_1` FOREIGN KEY (`id`) REFERENCES `notes_note` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notes_note_custom_fields`
--

LOCK TABLES `notes_note_custom_fields` WRITE;
/*!40000 ALTER TABLE `notes_note_custom_fields` DISABLE KEYS */;
/*!40000 ALTER TABLE `notes_note_custom_fields` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notes_note_image`
--

DROP TABLE IF EXISTS `notes_note_image`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `notes_note_image` (
  `noteId` int(11) NOT NULL,
  `blobId` binary(40) NOT NULL,
  PRIMARY KEY (`noteId`,`blobId`),
  KEY `blobId` (`blobId`),
  CONSTRAINT `notes_note_image_ibfk_1` FOREIGN KEY (`blobId`) REFERENCES `core_blob` (`id`),
  CONSTRAINT `notes_note_image_ibfk_2` FOREIGN KEY (`noteId`) REFERENCES `notes_note` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notes_note_image`
--

LOCK TABLES `notes_note_image` WRITE;
/*!40000 ALTER TABLE `notes_note_image` DISABLE KEYS */;
/*!40000 ALTER TABLE `notes_note_image` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notes_user_settings`
--

DROP TABLE IF EXISTS `notes_user_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `notes_user_settings` (
  `userId` int(11) NOT NULL,
  `defaultNoteBookId` int(11) DEFAULT NULL,
  PRIMARY KEY (`userId`),
  KEY `defaultNoteBookId` (`defaultNoteBookId`),
  CONSTRAINT `notes_user_settings_ibfk_1` FOREIGN KEY (`defaultNoteBookId`) REFERENCES `notes_note_book` (`id`) ON DELETE CASCADE,
  CONSTRAINT `notes_user_settings_ibfk_2` FOREIGN KEY (`userId`) REFERENCES `core_user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notes_user_settings`
--

LOCK TABLES `notes_user_settings` WRITE;
/*!40000 ALTER TABLE `notes_user_settings` DISABLE KEYS */;
INSERT INTO `notes_user_settings` VALUES (1,65);
/*!40000 ALTER TABLE `notes_user_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `smi_certs`
--

DROP TABLE IF EXISTS `smi_certs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `smi_certs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `cert` text COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `smi_certs`
--

LOCK TABLES `smi_certs` WRITE;
/*!40000 ALTER TABLE `smi_certs` DISABLE KEYS */;
/*!40000 ALTER TABLE `smi_certs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `smi_pkcs12`
--

DROP TABLE IF EXISTS `smi_pkcs12`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `smi_pkcs12` (
  `account_id` int(11) NOT NULL,
  `cert` blob DEFAULT NULL,
  `always_sign` tinyint(1) NOT NULL,
  PRIMARY KEY (`account_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `smi_pkcs12`
--

LOCK TABLES `smi_pkcs12` WRITE;
/*!40000 ALTER TABLE `smi_pkcs12` DISABLE KEYS */;
/*!40000 ALTER TABLE `smi_pkcs12` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `su_announcements`
--

DROP TABLE IF EXISTS `su_announcements`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `su_announcements` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT 0,
  `acl_id` int(11) NOT NULL,
  `due_time` int(11) NOT NULL DEFAULT 0,
  `ctime` int(11) NOT NULL DEFAULT 0,
  `mtime` int(11) NOT NULL DEFAULT 0,
  `title` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `content` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `due_time` (`due_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `su_announcements`
--

LOCK TABLES `su_announcements` WRITE;
/*!40000 ALTER TABLE `su_announcements` DISABLE KEYS */;
/*!40000 ALTER TABLE `su_announcements` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `su_latest_read_announcement_records`
--

DROP TABLE IF EXISTS `su_latest_read_announcement_records`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `su_latest_read_announcement_records` (
  `user_id` int(11) NOT NULL,
  `announcement_id` int(11) NOT NULL DEFAULT 0,
  `announcement_ctime` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `su_latest_read_announcement_records`
--

LOCK TABLES `su_latest_read_announcement_records` WRITE;
/*!40000 ALTER TABLE `su_latest_read_announcement_records` DISABLE KEYS */;
INSERT INTO `su_latest_read_announcement_records` VALUES (1,0,0);
/*!40000 ALTER TABLE `su_latest_read_announcement_records` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `su_notes`
--

DROP TABLE IF EXISTS `su_notes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `su_notes` (
  `user_id` int(11) NOT NULL,
  `text` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `su_notes`
--

LOCK TABLES `su_notes` WRITE;
/*!40000 ALTER TABLE `su_notes` DISABLE KEYS */;
INSERT INTO `su_notes` VALUES (1,NULL);
/*!40000 ALTER TABLE `su_notes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `su_rss_feeds`
--

DROP TABLE IF EXISTS `su_rss_feeds`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `su_rss_feeds` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `summary` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `su_rss_feeds`
--

LOCK TABLES `su_rss_feeds` WRITE;
/*!40000 ALTER TABLE `su_rss_feeds` DISABLE KEYS */;
/*!40000 ALTER TABLE `su_rss_feeds` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `su_visible_calendars`
--

DROP TABLE IF EXISTS `su_visible_calendars`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `su_visible_calendars` (
  `user_id` int(11) NOT NULL,
  `calendar_id` int(11) NOT NULL,
  PRIMARY KEY (`user_id`,`calendar_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `su_visible_calendars`
--

LOCK TABLES `su_visible_calendars` WRITE;
/*!40000 ALTER TABLE `su_visible_calendars` DISABLE KEYS */;
INSERT INTO `su_visible_calendars` VALUES (1,1);
/*!40000 ALTER TABLE `su_visible_calendars` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `su_visible_lists`
--

DROP TABLE IF EXISTS `su_visible_lists`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `su_visible_lists` (
  `user_id` int(11) NOT NULL,
  `tasklist_id` int(11) NOT NULL,
  PRIMARY KEY (`user_id`,`tasklist_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `su_visible_lists`
--

LOCK TABLES `su_visible_lists` WRITE;
/*!40000 ALTER TABLE `su_visible_lists` DISABLE KEYS */;
/*!40000 ALTER TABLE `su_visible_lists` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sync_addressbook_user`
--

DROP TABLE IF EXISTS `sync_addressbook_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sync_addressbook_user` (
  `addressBookId` int(11) NOT NULL,
  `userId` int(11) NOT NULL,
  `isDefault` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`addressBookId`,`userId`),
  KEY `userId` (`userId`),
  CONSTRAINT `sync_addressbook_user_ibfk_1` FOREIGN KEY (`addressBookId`) REFERENCES `addressbook_addressbook` (`id`) ON DELETE CASCADE,
  CONSTRAINT `sync_addressbook_user_ibfk_2` FOREIGN KEY (`userId`) REFERENCES `core_user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sync_addressbook_user`
--

LOCK TABLES `sync_addressbook_user` WRITE;
/*!40000 ALTER TABLE `sync_addressbook_user` DISABLE KEYS */;
INSERT INTO `sync_addressbook_user` VALUES (1,1,1);
/*!40000 ALTER TABLE `sync_addressbook_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sync_calendar_user`
--

DROP TABLE IF EXISTS `sync_calendar_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sync_calendar_user` (
  `calendar_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT 0,
  `default_calendar` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`calendar_id`,`user_id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sync_calendar_user`
--

LOCK TABLES `sync_calendar_user` WRITE;
/*!40000 ALTER TABLE `sync_calendar_user` DISABLE KEYS */;
/*!40000 ALTER TABLE `sync_calendar_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sync_devices`
--

DROP TABLE IF EXISTS `sync_devices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sync_devices` (
  `id` int(11) NOT NULL DEFAULT 0,
  `manufacturer` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `model` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `software_version` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_id` int(11) NOT NULL DEFAULT 0,
  `uri` varchar(128) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `UTC` enum('0','1') COLLATE utf8mb4_unicode_ci NOT NULL,
  `vcalendar_version` varchar(4) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sync_devices`
--

LOCK TABLES `sync_devices` WRITE;
/*!40000 ALTER TABLE `sync_devices` DISABLE KEYS */;
/*!40000 ALTER TABLE `sync_devices` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sync_note_categories_user`
--

DROP TABLE IF EXISTS `sync_note_categories_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sync_note_categories_user` (
  `category_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT 0,
  `default_category` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`category_id`,`user_id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sync_note_categories_user`
--

LOCK TABLES `sync_note_categories_user` WRITE;
/*!40000 ALTER TABLE `sync_note_categories_user` DISABLE KEYS */;
/*!40000 ALTER TABLE `sync_note_categories_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sync_settings`
--

DROP TABLE IF EXISTS `sync_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sync_settings` (
  `user_id` int(11) NOT NULL DEFAULT 0,
  `addressbook_id` int(11) NOT NULL DEFAULT 0,
  `calendar_id` int(11) NOT NULL DEFAULT 0,
  `tasklist_id` int(11) NOT NULL DEFAULT 0,
  `note_category_id` int(11) NOT NULL DEFAULT 0,
  `account_id` int(11) NOT NULL DEFAULT 0,
  `server_is_master` tinyint(1) NOT NULL DEFAULT 1,
  `max_days_old` tinyint(4) NOT NULL DEFAULT 0,
  `delete_old_events` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sync_settings`
--

LOCK TABLES `sync_settings` WRITE;
/*!40000 ALTER TABLE `sync_settings` DISABLE KEYS */;
INSERT INTO `sync_settings` VALUES (1,0,0,0,0,0,1,0,1);
/*!40000 ALTER TABLE `sync_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sync_tasklist_user`
--

DROP TABLE IF EXISTS `sync_tasklist_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sync_tasklist_user` (
  `tasklist_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT 0,
  `default_tasklist` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`tasklist_id`,`user_id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sync_tasklist_user`
--

LOCK TABLES `sync_tasklist_user` WRITE;
/*!40000 ALTER TABLE `sync_tasklist_user` DISABLE KEYS */;
/*!40000 ALTER TABLE `sync_tasklist_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sync_user_note_book`
--

DROP TABLE IF EXISTS `sync_user_note_book`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sync_user_note_book` (
  `noteBookId` int(11) NOT NULL,
  `userId` int(11) NOT NULL,
  `isDefault` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`noteBookId`,`userId`),
  KEY `user` (`userId`),
  CONSTRAINT `sync_user_note_book_user` FOREIGN KEY (`userId`) REFERENCES `core_user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sync_user_note_book`
--

LOCK TABLES `sync_user_note_book` WRITE;
/*!40000 ALTER TABLE `sync_user_note_book` DISABLE KEYS */;
INSERT INTO `sync_user_note_book` VALUES (65,1,1);
/*!40000 ALTER TABLE `sync_user_note_book` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ta_categories`
--

DROP TABLE IF EXISTS `ta_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ta_categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ta_categories`
--

LOCK TABLES `ta_categories` WRITE;
/*!40000 ALTER TABLE `ta_categories` DISABLE KEYS */;
/*!40000 ALTER TABLE `ta_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ta_portlet_tasklists`
--

DROP TABLE IF EXISTS `ta_portlet_tasklists`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ta_portlet_tasklists` (
  `user_id` int(11) NOT NULL,
  `tasklist_id` int(11) NOT NULL,
  PRIMARY KEY (`user_id`,`tasklist_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ta_portlet_tasklists`
--

LOCK TABLES `ta_portlet_tasklists` WRITE;
/*!40000 ALTER TABLE `ta_portlet_tasklists` DISABLE KEYS */;
/*!40000 ALTER TABLE `ta_portlet_tasklists` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ta_settings`
--

DROP TABLE IF EXISTS `ta_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ta_settings` (
  `user_id` int(11) NOT NULL,
  `reminder_days` int(11) NOT NULL DEFAULT 0,
  `reminder_time` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0',
  `remind` tinyint(1) NOT NULL DEFAULT 0,
  `default_tasklist_id` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ta_settings`
--

LOCK TABLES `ta_settings` WRITE;
/*!40000 ALTER TABLE `ta_settings` DISABLE KEYS */;
INSERT INTO `ta_settings` VALUES (1,0,'0',0,0);
/*!40000 ALTER TABLE `ta_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ta_tasklists`
--

DROP TABLE IF EXISTS `ta_tasklists`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ta_tasklists` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  `acl_id` int(11) NOT NULL,
  `files_folder_id` int(11) NOT NULL DEFAULT 0,
  `version` int(10) unsigned NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ta_tasklists`
--

LOCK TABLES `ta_tasklists` WRITE;
/*!40000 ALTER TABLE `ta_tasklists` DISABLE KEYS */;
/*!40000 ALTER TABLE `ta_tasklists` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ta_tasks`
--

DROP TABLE IF EXISTS `ta_tasks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ta_tasks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uuid` varchar(190) CHARACTER SET ascii COLLATE ascii_bin NOT NULL DEFAULT '',
  `tasklist_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `ctime` int(11) NOT NULL,
  `mtime` int(11) NOT NULL,
  `muser_id` int(11) NOT NULL DEFAULT 0,
  `start_time` int(11) NOT NULL,
  `due_time` int(11) NOT NULL,
  `completion_time` int(11) NOT NULL DEFAULT 0,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `repeat_end_time` int(11) NOT NULL DEFAULT 0,
  `reminder` int(11) NOT NULL DEFAULT 0,
  `rrule` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `files_folder_id` int(11) NOT NULL DEFAULT 0,
  `category_id` int(11) NOT NULL DEFAULT 0,
  `priority` int(11) NOT NULL DEFAULT 1,
  `percentage_complete` tinyint(4) NOT NULL DEFAULT 0,
  `project_id` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `list_id` (`tasklist_id`),
  KEY `rrule` (`rrule`),
  KEY `uuid` (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ta_tasks`
--

LOCK TABLES `ta_tasks` WRITE;
/*!40000 ALTER TABLE `ta_tasks` DISABLE KEYS */;
/*!40000 ALTER TABLE `ta_tasks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ta_tasks_custom_fields`
--

DROP TABLE IF EXISTS `ta_tasks_custom_fields`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ta_tasks_custom_fields` (
  `id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `ta_tasks_custom_fields_ibfk_1` FOREIGN KEY (`id`) REFERENCES `ta_tasks` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ta_tasks_custom_fields`
--

LOCK TABLES `ta_tasks_custom_fields` WRITE;
/*!40000 ALTER TABLE `ta_tasks_custom_fields` DISABLE KEYS */;
/*!40000 ALTER TABLE `ta_tasks_custom_fields` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `zpa_devices`
--

DROP TABLE IF EXISTS `zpa_devices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `zpa_devices` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `device_id` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `device_type` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `remote_addr` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `can_connect` tinyint(1) NOT NULL DEFAULT 0,
  `ctime` int(11) NOT NULL,
  `mtime` int(11) NOT NULL,
  `new` tinyint(1) NOT NULL DEFAULT 1,
  `username` varchar(190) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `comment` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `as_version` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `device_id` (`device_id`,`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `zpa_devices`
--

LOCK TABLES `zpa_devices` WRITE;
/*!40000 ALTER TABLE `zpa_devices` DISABLE KEYS */;
/*!40000 ALTER TABLE `zpa_devices` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2020-07-25 16:49:27
