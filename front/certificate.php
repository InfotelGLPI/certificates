<?php
/*
 * @version $Id: HEADER 15930 2011-10-30 15:47:55Z tsmr $
 -------------------------------------------------------------------------
 certificates plugin for GLPI
 Copyright (C) 2009-2016 by the certificates Development Team.

 https://github.com/InfotelGLPI/certificates
 -------------------------------------------------------------------------

 LICENSE

 This file is part of certificates.

 certificates is free software; you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation; either version 2 of the License, or
 (at your option) any later version.

 certificates is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with certificates. If not, see <http://www.gnu.org/licenses/>.
 --------------------------------------------------------------------------
 */

include('../../../inc/includes.php');

Html::header(_n('Certificate', 'Certificates', 2, 'certificates'), '', "assets", "plugincertificatesmenu");

if (!isset($_POST['do_migration'])) {
   $_POST['do_migration'] = "0";
}

echo "<div align='center'><h1>".__('Core migration', 'certificates')."</h1><br/>";

if ($DB->tableExists("glpi_plugin_certificates_certificates") && $_POST['do_migration'] == 1) {
   echo "<table align='center'><tr><td>";

   Html::showSimpleForm($_SERVER['PHP_SELF'], 'migration', __('Core migration', 'certificates'),
                        array('do_migration' => '1'),'','',
                        array(__('Are you sure you want to do core migration ??', 'certificates'),
                              __('Warning existants Certificates will be migrated !!', 'certificates')));

   echo "</td></tr></table>";

   echo "<br><span class='red b'>".__('Warning existants Certificates will be migrated !!', 'certificates')."</span>";

   echo "<br>";
   echo __('Data migration', 'certificates');
   
   //certificatetypes
   $query_selecttypes = "SELECT * FROM `glpi_plugin_certificates_certificatetypes`;";
   $result_selecttypes = $DB->query($query_selecttypes);

   if($DB->numrows($result_selecttypes) > 0) {
      while ($data_selecttypes = $DB->fetch_assoc($result_selecttypes)) {
         $id_type = $data_selecttypes['id'];

         $DB->query("INSERT INTO `glpi_certificatetypes`(`entities_id`, `is_recursive`, `name`, `comment`) 
                    SELECT `entities_id`, 1, `name`, `comment` 
                    FROM `glpi_plugin_certificates_certificatetypes` 
                    WHERE `id` = $id_type");

         //ID inserted
         $result = $DB->query("SELECT `id`
                    FROM `glpi_certificatetypes` 
                    WHERE `name` LIKE '".$data_selecttypes['name']."'");

         $last_id = $DB->result($result, 0, "id");

         $DB->query("UPDATE `glpi_plugin_certificates_certificates` 
                     SET `plugin_certificates_certificatetypes_id` = $last_id
                     WHERE `plugin_certificates_certificatetypes_id` = $id_type");

         $DB->query("UPDATE `glpi_dropdowntranslations` 
                     SET `items_id` = $last_id, `itemtype` = 'CertificateType'
                     WHERE `items_id` = $id_type 
                     AND `itemtype` = 'PluginCertificatesCertificateType'");
      }
   }


   //states
   $query_selectstates = "SELECT * FROM `glpi_plugin_certificates_certificatestates`;";
   $result_selectstates = $DB->query($query_selectstates);

   if($DB->numrows($result_selectstates) > 0) {
      while ($data_selectstates = $DB->fetch_assoc($result_selectstates)) {
         $id_states = $data_selectstates['id'];

         $result = $DB->query("SELECT `id`
                             FROM `glpi_states` 
                             WHERE `completename` LIKE '".$data_selectstates['name']."'");
         $last_id = $DB->result($result, 0, "id");

         if ($last_id == null) {

            $DB->query("INSERT INTO `glpi_states`(`entities_id`, `name`, `completename`, `comment`, `is_recursive`, 
                                              `is_visible_computer`, `is_visible_monitor`, `is_visible_networkequipment`,
                                              `is_visible_peripheral`, `is_visible_phone`, `is_visible_printer`,
                                              `is_visible_softwareversion`, `is_visible_softwarelicense`, `is_visible_line`) 
                    SELECT `entities_id`, `name`, `name`, `comment`, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0
                    FROM `glpi_plugin_certificates_certificatestates` 
                    WHERE `id` = $id_states");

            //ID inserted
            $result = $DB->query("SELECT `id`
                    FROM `glpi_states` 
                    WHERE `name` LIKE '".$data_selectstates['name']."'");

            $last_id = $DB->result($result, 0, "id");
         }

         $DB->query("UPDATE `glpi_plugin_certificates_certificates` 
                     SET `states_id` = $last_id
                     WHERE `plugin_certificates_certificatestates_id` = $id_states");

      }
   }


   //certificates
   $query_selectcertificates = "SELECT * FROM `glpi_plugin_certificates_certificates`;";
   $result_selectcertificates = $DB->query($query_selectcertificates);

   if($DB->numrows($result_selectcertificates) > 0) {
      while ($data_selectcertificates = $DB->fetch_assoc($result_selectcertificates)) {
         $id_certificates = $data_selectcertificates['id'];

         $DB->query("INSERT INTO `glpi_certificates`(`name`, `entities_id`, `is_recursive`, `is_deleted`, `certificatetypes_id`,
                                                    `dns_name`, `dns_suffix`, `users_id_tech`, `groups_id_tech`, `locations_id`,
                                                    `manufacturers_id`, `is_autosign`, `date_expiration`, `states_id`, `command`,
                                                    `certificate_request`, `certificate_item`, `date_mod`) 
                    SELECT `name`, `entities_id`, `is_recursive`, `is_deleted`, `plugin_certificates_certificatetypes_id`,
                                                    `dns_name`, `dns_suffix`, `users_id_tech`, `groups_id_tech`, `locations_id`,
                                                    `manufacturers_id`, `auto_sign`, `date_expiration`, 
                                                    `plugin_certificates_certificatestates_id`, `command`,
                                                    `certificate_request`, `certificate_item`, `date_mod`
                    FROM `glpi_plugin_certificates_certificates` 
                    WHERE `id` = $id_certificates");
         $last_id = $DB->insert_id();

         $DB->query("UPDATE `glpi_plugin_certificates_certificates_items` 
                     SET `plugin_certificates_certificates_id` = $last_id
                     WHERE `plugin_certificates_certificates_id` = $id_certificates");

         $tables_glpi = array("glpi_documents_items",
                              "glpi_logs",
                              "glpi_items_tickets",
                              "glpi_contracts_items",
                              "glpi_notepads",
                              "glpi_items_problems");

         foreach ($tables_glpi as $table_glpi) {

            $DB->query("UPDATE `$table_glpi` 
                     SET `items_id` = $last_id, `itemtype` = 'Certificate'
                     WHERE `items_id` = $id_certificates 
                     AND `itemtype` = 'PluginCertificatesCertificate'");
         }

         $plugin = new Plugin();
         if ($plugin->isActivated('account')) {

            $DB->query("UPDATE `glpi_plugin_accounts_accounts_items` 
                     SET `items_id` = $last_id, `itemtype` = 'Certificate'
                     WHERE `items_id` = $id_certificates 
                     AND `itemtype` = 'PluginCertificatesCertificate'");
         }

      }
   }

   //certificates item
   $DB->query("INSERT INTO `glpi_certificates_items`(`certificates_id`, `items_id`, `itemtype`)
              SELECT `plugin_certificates_certificates_id`, `items_id`, `itemtype` 
              FROM `glpi_plugin_certificates_certificates_items`");



   echo "<br>";
   echo __('Tables purge', 'certificates');

   $tables = array("glpi_plugin_certificates_certificates",
                   "glpi_plugin_certificates_certificates_items",
                   "glpi_plugin_certificates_certificatetypes",
                   "glpi_plugin_certificates_certificatestates",
                   "glpi_plugin_certificates_configs",
                   "glpi_plugin_certificates_notificationstates");

   foreach ($tables as $table) {
      $DB->query("DROP TABLE IF EXISTS `$table`;");
   }
   //old versions
   $tables = array("glpi_plugin_certificates",
                   "glpi_plugin_certificates_profiles",
                   "glpi_plugin_certificates_device",
                   "glpi_dropdown_plugin_certificates_type",
                   "glpi_dropdown_plugin_certificates_status",
                   "glpi_plugin_certificates_config",
                   "glpi_plugin_certificates_mailing",
                   "glpi_plugin_certificates_default");

   foreach ($tables as $table) {
      $DB->query("DROP TABLE IF EXISTS `$table`;");
   }
   echo "<br>";
   echo __('Link with core purge', 'certificates');
   
   $tables_glpi = array("glpi_displaypreferences",
                        "glpi_documents_items",
                        "glpi_savedsearches",
                        "glpi_logs",
                        "glpi_items_tickets",
                        "glpi_contracts_items",
                        "glpi_items_problems",
                        "glpi_notepads",
                        "glpi_dropdowntranslations");

   foreach ($tables_glpi as $table_glpi) {
      $DB->query("DELETE FROM `$table_glpi` WHERE `itemtype` LIKE 'PluginCertificates%';");
   }
   
   echo "<br>";
   echo __('Notifications purge', 'certificates');
   
   $notif   = new Notification();
   $options = array('itemtype' => 'PluginCertificatesCertificate',
                    'FIELDS'   => 'id');
   foreach ($DB->request('glpi_notifications', $options) as $data) {
      $notif->delete($data);
   }

   //templates
   $template    = new NotificationTemplate();
   $translation = new NotificationTemplateTranslation();
   $options     = array('itemtype' => 'PluginCertificatesCertificate',
                        'FIELDS'   => 'id');
   foreach ($DB->request('glpi_notificationtemplates', $options) as $data) {
      $options_template = array('notificationtemplates_id' => $data['id'],
                                'FIELDS'                   => 'id');

      foreach ($DB->request('glpi_notificationtemplatetranslations', $options_template) as $data_template) {
         $translation->delete($data_template);
      }
      $template->delete($data);
   }
   
   CronTask::Unregister('CertificatesAlert');
} else {
   echo "<br>";
   echo __('No data to migrate', 'certificates');

}
echo __('You can uninstall the plugin', 'certificates');
echo "</div>";
Html::footer();