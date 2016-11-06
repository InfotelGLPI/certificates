DROP TABLE IF EXISTS `glpi_plugin_certificates_certificates`;
CREATE TABLE `glpi_plugin_certificates_certificates` (
  `id`                                       INT(11)     NOT NULL     AUTO_INCREMENT,
  `entities_id`                              INT(11)     NOT NULL     DEFAULT '0',
  `is_recursive`                             TINYINT(1)  NOT NULL     DEFAULT '0',
  `name`                                     VARCHAR(255)
                                             COLLATE utf8_unicode_ci  DEFAULT NULL,
  `plugin_certificates_certificatetypes_id`  INT(11)     NOT NULL     DEFAULT '0'
  COMMENT 'RELATION to glpi_plugin_certificates_certificatetypes (id)',
  `dns_name`                                 VARCHAR(255)
                                             COLLATE utf8_unicode_ci  DEFAULT NULL,
  `dns_suffix`                               VARCHAR(255)
                                             COLLATE utf8_unicode_ci  DEFAULT NULL,
  `users_id_tech`                            INT(11)     NOT NULL     DEFAULT '0'
  COMMENT 'RELATION to glpi_users (id)',
  `groups_id_tech`                           INT(11)     NOT NULL     DEFAULT '0'
  COMMENT 'RELATION to glpi_groups (id)',
  `locations_id`                             INT(11)     NOT NULL     DEFAULT '0'
  COMMENT 'RELATION to glpi_locations (id)',
  `manufacturers_id`                         INT(11)     NOT NULL     DEFAULT '0'
  COMMENT 'RELATION to glpi_manufacturers (id)',
  `auto_sign`                                SMALLINT(6) NOT NULL     DEFAULT '0',
  `date_query`                               DATE                     DEFAULT NULL,
  `date_expiration`                          DATE                     DEFAULT NULL,
  `plugin_certificates_certificatestates_id` INT(11)     NOT NULL     DEFAULT '0'
  COMMENT 'RELATION to glpi_plugin_certificates_certificatestates (id)',
  `mailing`                                  INT(11)     NOT NULL     DEFAULT '0',
  `command`                                  TEXT COLLATE utf8_unicode_ci,
  `certificate_request`                      TEXT COLLATE utf8_unicode_ci,
  `certificate_item`                         TEXT COLLATE utf8_unicode_ci,
  `is_helpdesk_visible`                      INT(11)     NOT NULL     DEFAULT '1',
  `date_mod`                                 DATETIME                 DEFAULT NULL,
  `is_deleted`                               TINYINT(1)  NOT NULL     DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `name` (`name`),
  KEY `entities_id` (`entities_id`),
  KEY `plugin_certificates_certificatetypes_id` (`plugin_certificates_certificatetypes_id`),
  KEY `users_id_tech` (`users_id_tech`),
  KEY `groups_id_tech` (`groups_id_tech`),
  KEY `locations_id` (`locations_id`),
  KEY `manufacturers_id` (`manufacturers_id`),
  KEY `plugin_certificates_certificatestates_id` (`plugin_certificates_certificatestates_id`),
  KEY `date_mod` (`date_mod`),
  KEY `is_helpdesk_visible` (`is_helpdesk_visible`),
  KEY `is_deleted` (`is_deleted`)
)
  ENGINE = MyISAM
  DEFAULT CHARSET = utf8
  COLLATE = utf8_unicode_ci;

DROP TABLE IF EXISTS `glpi_plugin_certificates_certificates_items`;
CREATE TABLE `glpi_plugin_certificates_certificates_items` (
  `id`                                  INT(11)                 NOT NULL AUTO_INCREMENT,
  `plugin_certificates_certificates_id` INT(11)                 NOT NULL DEFAULT '0',
  `items_id`                            INT(11)                 NOT NULL DEFAULT '0'
  COMMENT 'RELATION to various tables, according to itemtype (id)',
  `itemtype`                            VARCHAR(100)
                                        COLLATE utf8_unicode_ci NOT NULL
  COMMENT 'see .class.php file',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unicity` (`plugin_certificates_certificates_id`, `itemtype`, `items_id`),
  KEY `FK_device` (`items_id`, `itemtype`),
  KEY `item` (`itemtype`, `items_id`)
)
  ENGINE = MyISAM
  DEFAULT CHARSET = utf8
  COLLATE = utf8_unicode_ci;

DROP TABLE IF EXISTS `glpi_plugin_certificates_certificatetypes`;
CREATE TABLE `glpi_plugin_certificates_certificatetypes` (
  `id`          INT(11) NOT NULL        AUTO_INCREMENT,
  `entities_id` INT(11) NOT NULL        DEFAULT '0',
  `name`        VARCHAR(255)
                COLLATE utf8_unicode_ci DEFAULT NULL,
  `comment`     TEXT COLLATE utf8_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `name` (`name`)
)
  ENGINE = MyISAM
  DEFAULT CHARSET = utf8
  COLLATE = utf8_unicode_ci;

DROP TABLE IF EXISTS `glpi_plugin_certificates_certificatestates`;
CREATE TABLE `glpi_plugin_certificates_certificatestates` (
  `id`          INT(11) NOT NULL        AUTO_INCREMENT,
  `entities_id` INT(11) NOT NULL        DEFAULT '0',
  `name`        VARCHAR(255)
                COLLATE utf8_unicode_ci DEFAULT NULL,
  `comment`     TEXT COLLATE utf8_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `name` (`name`)
)
  ENGINE = MyISAM
  DEFAULT CHARSET = utf8
  COLLATE = utf8_unicode_ci;

DROP TABLE IF EXISTS `glpi_plugin_certificates_configs`;
CREATE TABLE `glpi_plugin_certificates_configs` (
  `id`                INT(11)                 NOT NULL AUTO_INCREMENT,
  `delay_expired`     VARCHAR(50)
                      COLLATE utf8_unicode_ci NOT NULL DEFAULT '30',
  `delay_whichexpire` VARCHAR(50)
                      COLLATE utf8_unicode_ci NOT NULL DEFAULT '30',
  PRIMARY KEY (`id`)
)
  ENGINE = MyISAM
  DEFAULT CHARSET = utf8
  COLLATE = utf8_unicode_ci;

INSERT INTO `glpi_plugin_certificates_configs` VALUES (1, '30', '30');

DROP TABLE IF EXISTS `glpi_plugin_certificates_notificationstates`;
CREATE TABLE `glpi_plugin_certificates_notificationstates` (
  `id`                                       INT(11) NOT NULL AUTO_INCREMENT,
  `plugin_certificates_certificatestates_id` INT(11) NOT NULL DEFAULT '0'
  COMMENT 'RELATION to glpi_plugin_certificates_certificatestates (id)',
  PRIMARY KEY (`id`),
  KEY `plugin_certificates_certificatestates_id` (`plugin_certificates_certificatestates_id`)
)
  ENGINE = MyISAM
  DEFAULT CHARSET = utf8
  COLLATE = utf8_unicode_ci;

INSERT INTO `glpi_notificationtemplates`
VALUES (NULL, 'Alert Certificates', 'PluginCertificatesCertificate', '2010-02-24 21:34:46', '', NULL);

INSERT INTO `glpi_displaypreferences` VALUES (NULL, 'PluginCertificatesCertificate', '3', '2', '0');
INSERT INTO `glpi_displaypreferences` VALUES (NULL, 'PluginCertificatesCertificate', '4', '3', '0');
INSERT INTO `glpi_displaypreferences` VALUES (NULL, 'PluginCertificatesCertificate', '5', '4', '0');