ALTER TABLE `glpi_plugin_certificates`
  RENAME `glpi_plugin_certificates_certificates`;
ALTER TABLE `glpi_plugin_certificates_device`
  RENAME `glpi_plugin_certificates_certificates_items`;
ALTER TABLE `glpi_dropdown_plugin_certificates_type`
  RENAME `glpi_plugin_certificates_certificatetypes`;
ALTER TABLE `glpi_dropdown_plugin_certificates_status`
  RENAME `glpi_plugin_certificates_certificatestates`;
ALTER TABLE `glpi_plugin_certificates_default`
  RENAME `glpi_plugin_certificates_notificationstates`;
ALTER TABLE `glpi_plugin_certificates_config`
  RENAME `glpi_plugin_certificates_configs`;
DROP TABLE IF EXISTS `glpi_plugin_certificates_mailing`;

UPDATE `glpi_plugin_certificates_certificates`
SET `FK_users` = '0'
WHERE `FK_users` IS NULL;
UPDATE `glpi_plugin_certificates_certificates`
SET `FK_groups` = '0'
WHERE `FK_groups` IS NULL;

ALTER TABLE `glpi_plugin_certificates_certificates`
  CHANGE `ID` `id` INT(11) NOT NULL AUTO_INCREMENT,
  CHANGE `FK_entities` `entities_id` INT(11) NOT NULL DEFAULT '0',
  CHANGE `recursive` `is_recursive` TINYINT(1) NOT NULL DEFAULT '0',
  CHANGE `name` `name` VARCHAR(255)
COLLATE utf8_unicode_ci DEFAULT NULL,
  CHANGE `type` `plugin_certificates_certificatetypes_id` INT(11) NOT NULL DEFAULT '0'
COMMENT 'RELATION to glpi_plugin_certificates_certificatetypes (id)',
  CHANGE `dns_name` `dns_name` VARCHAR(255)
COLLATE utf8_unicode_ci DEFAULT NULL,
  CHANGE `dns_suffix` `dns_suffix` VARCHAR(255)
COLLATE utf8_unicode_ci DEFAULT NULL,
  CHANGE `FK_users` `users_id` INT(11) NOT NULL DEFAULT '0'
COMMENT 'RELATION to glpi_users (id)',
  CHANGE `FK_groups` `groups_id` INT(11) NOT NULL DEFAULT '0'
COMMENT 'RELATION to glpi_groups (id)',
  CHANGE `location` `locations_id` INT(11) NOT NULL DEFAULT '0'
COMMENT 'RELATION to glpi_locations (id)',
  CHANGE `FK_glpi_enterprise` `manufacturers_id` INT(11) NOT NULL DEFAULT '0'
COMMENT 'RELATION to glpi_manufacturers (id)',
  CHANGE `query_date` `date_query` DATE DEFAULT NULL,
  CHANGE `expiration_date` `date_expiration` DATE DEFAULT NULL,
  CHANGE `status` `plugin_certificates_certificatestates_id` INT(11) NOT NULL DEFAULT '0'
COMMENT 'RELATION to glpi_plugin_certificates_certificatestates (id)',
  CHANGE `mailing` `mailing` INT(11) NOT NULL DEFAULT '0',
  CHANGE `command` `command` TEXT COLLATE utf8_unicode_ci,
  CHANGE `certificate_request` `certificate_request` TEXT COLLATE utf8_unicode_ci,
  CHANGE `certificate_item` `certificate_item` TEXT COLLATE utf8_unicode_ci,
  CHANGE `helpdesk_visible` `is_helpdesk_visible` INT(11) NOT NULL DEFAULT '1',
  CHANGE `notes` `notepad` LONGTEXT COLLATE utf8_unicode_ci,
  CHANGE `deleted` `is_deleted` TINYINT(1) NOT NULL DEFAULT '0',
  ADD INDEX (`name`),
  ADD INDEX (`entities_id`),
  ADD INDEX (`plugin_certificates_certificatetypes_id`),
  ADD INDEX (`users_id`),
  ADD INDEX (`groups_id`),
  ADD INDEX (`locations_id`),
  ADD INDEX (`manufacturers_id`),
  ADD INDEX (`plugin_certificates_certificatestates_id`),
  ADD INDEX (`date_mod`),
  ADD INDEX (`is_helpdesk_visible`),
  ADD INDEX (`is_deleted`);

ALTER TABLE `glpi_plugin_certificates_certificates_items`
  DROP INDEX `FK_certificate`,
  DROP INDEX `FK_certificate_2`,
  DROP INDEX `FK_device`,
  CHANGE `ID` `id` INT(11) NOT NULL AUTO_INCREMENT,
  CHANGE `FK_certificate` `plugin_certificates_certificates_id` INT(11) NOT NULL DEFAULT '0',
  CHANGE `FK_device` `items_id` INT(11) NOT NULL DEFAULT '0'
COMMENT 'RELATION to various tables, according to itemtype (id)',
  CHANGE `device_type` `itemtype` VARCHAR(100)
COLLATE utf8_unicode_ci NOT NULL
COMMENT 'see .class.php file',
  ADD UNIQUE `unicity` (`plugin_certificates_certificates_id`, `itemtype`, `items_id`),
  ADD INDEX `FK_device` (`items_id`, `itemtype`),
  ADD INDEX `item` (`itemtype`, `items_id`);

ALTER TABLE `glpi_plugin_certificates_certificatetypes`
  CHANGE `ID` `id` INT(11) NOT NULL AUTO_INCREMENT,
  CHANGE `FK_entities` `entities_id` INT(11) NOT NULL DEFAULT '0',
  CHANGE `name` `name` VARCHAR(255)
COLLATE utf8_unicode_ci DEFAULT NULL,
  CHANGE `comments` `comment` TEXT COLLATE utf8_unicode_ci;

ALTER TABLE `glpi_plugin_certificates_certificatestates`
  CHANGE `ID` `id` INT(11) NOT NULL AUTO_INCREMENT,
  CHANGE `FK_entities` `entities_id` INT(11) NOT NULL DEFAULT '0',
  CHANGE `name` `name` VARCHAR(255)
COLLATE utf8_unicode_ci DEFAULT NULL,
  CHANGE `comments` `comment` TEXT COLLATE utf8_unicode_ci;

ALTER TABLE `glpi_plugin_certificates_profiles`
  CHANGE `ID` `id` INT(11) NOT NULL AUTO_INCREMENT,
  ADD `profiles_id` INT(11) NOT NULL DEFAULT '0'
COMMENT 'RELATION to glpi_profiles (id)',
  CHANGE `certificates` `certificates` CHAR(1)
COLLATE utf8_unicode_ci DEFAULT NULL,
  CHANGE `open_ticket` `open_ticket` CHAR(1)
COLLATE utf8_unicode_ci DEFAULT NULL,
  ADD INDEX (`profiles_id`);

ALTER TABLE `glpi_plugin_certificates_notificationstates`
  CHANGE `ID` `id` INT(11) NOT NULL AUTO_INCREMENT,
  CHANGE `status` `plugin_certificates_certificatestates_id` INT(11) NOT NULL DEFAULT '0'
COMMENT 'RELATION to glpi_plugin_certificates_certificatestates (id)',
  ADD INDEX (`plugin_certificates_certificatestates_id`);

ALTER TABLE `glpi_plugin_certificates_configs`
  CHANGE `ID` `id` INT(11) NOT NULL AUTO_INCREMENT,
  CHANGE `delay` `delay_expired` VARCHAR(50)
COLLATE utf8_unicode_ci NOT NULL DEFAULT '30',
  ADD `delay_whichexpire` VARCHAR(50)
COLLATE utf8_unicode_ci NOT NULL DEFAULT '30';

INSERT INTO `glpi_notificationtemplates` (`name`, `itemtype`, `date_mod`)
VALUES ('Alert Certificates', 'PluginCertificatesCertificate', '2010-02-24 21:34:46');