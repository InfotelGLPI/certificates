DROP TABLE IF EXISTS `glpi_plugin_certificates`;
CREATE TABLE `glpi_plugin_certificates` (
  `ID`                  INT(11)                 NOT NULL AUTO_INCREMENT,
  `FK_entities`         INT(11)                 NOT NULL DEFAULT '0',
  `recursive`           TINYINT(1)              NOT NULL DEFAULT '0',
  `name`                VARCHAR(255)
                        COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `type`                TINYINT(4)              NOT NULL DEFAULT '1',
  `dns_name`            VARCHAR(30)
                        COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `dns_suffix`          VARCHAR(30)
                        COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `FK_users`            INT(4)                  NOT NULL DEFAULT '0',
  `FK_groups`           INT(4)                  NOT NULL DEFAULT '0',
  `location`            INT(4)                  NOT NULL DEFAULT '0',
  `FK_glpi_enterprise`  INT(4)                  NOT NULL DEFAULT '0',
  `auto_sign`           SMALLINT(6)             NOT NULL DEFAULT '0',
  `query_date`          DATE                    NOT NULL DEFAULT '0000-00-00',
  `expiration_date`     DATE                    NOT NULL DEFAULT '0000-00-00',
  `status`              INT(4)                  NOT NULL DEFAULT '0',
  `mailing`             INT(4)                  NOT NULL DEFAULT '0',
  `command`             TEXT,
  `certificate_request` TEXT,
  `certificate_item`    TEXT,
  `notes`               LONGTEXT,
  `deleted`             SMALLINT(6)             NOT NULL DEFAULT '0',
  PRIMARY KEY (`ID`)
)
  ENGINE = MyISAM
  DEFAULT CHARSET = utf8
  COLLATE = utf8_unicode_ci;

DROP TABLE IF EXISTS `glpi_plugin_certificates_device`;
CREATE TABLE `glpi_plugin_certificates_device` (
  `ID`             INT(11) NOT NULL AUTO_INCREMENT,
  `FK_certificate` INT(11) NOT NULL DEFAULT '0',
  `FK_device`      INT(11) NOT NULL DEFAULT '0',
  `device_type`    INT(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `FK_certificate` (`FK_certificate`, `FK_device`, `device_type`),
  KEY `FK_certificate_2` (`FK_certificate`),
  KEY `FK_device` (`FK_device`, `device_type`)
)
  ENGINE = MyISAM
  DEFAULT CHARSET = utf8
  COLLATE = utf8_unicode_ci;

DROP TABLE IF EXISTS `glpi_dropdown_plugin_certificates_type`;
CREATE TABLE `glpi_dropdown_plugin_certificates_type` (
  `ID`          INT(11)                 NOT NULL AUTO_INCREMENT,
  `FK_entities` INT(11)                 NOT NULL DEFAULT '0',
  `name`        VARCHAR(255)
                COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `comments`    TEXT,
  PRIMARY KEY (`ID`),
  KEY `name` (`name`)
)
  ENGINE = MyISAM
  DEFAULT CHARSET = utf8
  COLLATE = utf8_unicode_ci;

DROP TABLE IF EXISTS `glpi_dropdown_plugin_certificates_status`;
CREATE TABLE `glpi_dropdown_plugin_certificates_status` (
  `ID`          INT(11)                 NOT NULL AUTO_INCREMENT,
  `FK_entities` INT(11)                 NOT NULL DEFAULT '0',
  `name`        VARCHAR(255)
                COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `comments`    TEXT,
  PRIMARY KEY (`ID`),
  KEY `name` (`name`)
)
  ENGINE = MyISAM
  DEFAULT CHARSET = utf8
  COLLATE = utf8_unicode_ci;

DROP TABLE IF EXISTS `glpi_plugin_certificates_profiles`;
CREATE TABLE `glpi_plugin_certificates_profiles` (
  `ID`           INT(11)                 NOT NULL        AUTO_INCREMENT,
  `name`         VARCHAR(255)
                 COLLATE utf8_unicode_ci                 DEFAULT NULL,
  `interface`    VARCHAR(50)
                 COLLATE utf8_unicode_ci NOT NULL        DEFAULT 'certificate',
  `is_default`   SMALLINT(6)             NOT NULL        DEFAULT '0',
  `certificates` CHAR(1)                                 DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `interface` (`interface`)
)
  ENGINE = MyISAM
  DEFAULT CHARSET = utf8
  COLLATE = utf8_unicode_ci;

DROP TABLE IF EXISTS `glpi_plugin_certificates_config`;
CREATE TABLE `glpi_plugin_certificates_config` (
  `ID`    INT(11)                 NOT NULL AUTO_INCREMENT,
  `delay` VARCHAR(50)
          COLLATE utf8_unicode_ci NOT NULL DEFAULT '30',
  PRIMARY KEY (`ID`)
)
  ENGINE = MyISAM
  DEFAULT CHARSET = utf8
  COLLATE = utf8_unicode_ci;

INSERT INTO `glpi_plugin_certificates_config` VALUES (1, '30');

DROP TABLE IF EXISTS `glpi_plugin_certificates_mailing`;
CREATE TABLE `glpi_plugin_certificates_mailing` (
  `ID`        INT(11) NOT NULL        AUTO_INCREMENT,
  `type`      VARCHAR(255)
              COLLATE utf8_unicode_ci DEFAULT NULL,
  `FK_item`   INT(11) NOT NULL        DEFAULT '0',
  `item_type` INT(11) NOT NULL        DEFAULT '0',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `mailings` (`type`, `FK_item`, `item_type`),
  KEY `type` (`type`),
  KEY `FK_item` (`FK_item`),
  KEY `item_type` (`item_type`),
  KEY `items` (`item_type`, `FK_item`)
)
  ENGINE = MyISAM
  DEFAULT CHARSET = utf8
  COLLATE = utf8_unicode_ci;

INSERT INTO glpi_plugin_certificates_mailing VALUES ('1', 'certificates', '1', '1');

INSERT INTO `glpi_display` (`ID`, `type`, `num`, `rank`, `FK_users`) VALUES (NULL, '1700', '3', '2', '0');
INSERT INTO `glpi_display` (`ID`, `type`, `num`, `rank`, `FK_users`) VALUES (NULL, '1700', '4', '3', '0');
INSERT INTO `glpi_display` (`ID`, `type`, `num`, `rank`, `FK_users`) VALUES (NULL, '1700', '5', '4', '0');