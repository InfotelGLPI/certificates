ALTER TABLE `glpi_plugin_certificates`
  ADD `recursive` TINYINT(1) NOT NULL DEFAULT '0'
  AFTER `FK_entities`;