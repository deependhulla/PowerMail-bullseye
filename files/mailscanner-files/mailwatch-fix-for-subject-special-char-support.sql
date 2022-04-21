
ALTER TABLE `mailscanner`.`maillog` CHANGE `subject` `subject` TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL ;

ALTER TABLE `mailscanner`.`maillog` CHANGE `headers` `headers` MEDIUMTEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL;



