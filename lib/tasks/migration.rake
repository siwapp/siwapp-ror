namespace :siwapp do
  desc "Makes the migration of old siwapp (sf1) to new one."
  task :migrate_old_database do
    # Get db config from databases.yml for the current environment
    client = Mysql2::Client.new(**ActiveRecord::Base.connection_config)

    client.query("ALTER TABLE common DROP FOREIGN KEY common_recurring_invoice_id_common_id")
    client.query("ALTER TABLE common DROP FOREIGN KEY common_customer_id_customer_id")
    client.query("ALTER TABLE common DROP FOREIGN KEY common_series_id_series_id")
    client.query("ALTER TABLE item DROP FOREIGN KEY item_common_id_common_id")
    client.query("ALTER TABLE item DROP FOREIGN KEY item_product_id_product_id")
    client.query("ALTER TABLE item_tax DROP FOREIGN KEY item_tax_item_id_item_id")
    client.query("ALTER TABLE payment DROP FOREIGN KEY payment_invoice_id_common_id")
    client.query("ALTER TABLE sf_guard_group_permission DROP FOREIGN KEY sf_guard_group_permission_group_id_sf_guard_group_id")
    client.query("ALTER TABLE sf_guard_group_permission DROP FOREIGN KEY sf_guard_group_permission_permission_id_sf_guard_permission_id")
    client.query("ALTER TABLE sf_guard_remember_key DROP FOREIGN KEY sf_guard_remember_key_user_id_sf_guard_user_id")
    client.query("ALTER TABLE sf_guard_user_group DROP FOREIGN KEY sf_guard_user_group_group_id_sf_guard_group_id")
    client.query("ALTER TABLE sf_guard_user_group DROP FOREIGN KEY sf_guard_user_group_user_id_sf_guard_user_id")
    client.query("ALTER TABLE sf_guard_user_permission DROP FOREIGN KEY sf_guard_user_permission_permission_id_sf_guard_permission_id")
    client.query("ALTER TABLE sf_guard_user_permission DROP FOREIGN KEY sf_guard_user_permission_user_id_sf_guard_user_id")
    client.query("ALTER TABLE sf_guard_user_profile DROP FOREIGN KEY sf_guard_user_profile_sf_guard_user_id_sf_guard_user_id")

    client.query("DROP TABLE sf_guard_group")
    client.query("DROP TABLE sf_guard_group_permission")
    client.query("DROP TABLE sf_guard_permission")
    client.query("DROP TABLE sf_guard_remember_key")
    client.query("DROP TABLE sf_guard_user")
    client.query("DROP TABLE sf_guard_user_group")
    client.query("DROP TABLE sf_guard_user_permission")
    client.query("DROP TABLE sf_guard_user_profile")
    client.query("DROP TABLE migration_version")

    client.query("CREATE TABLE `users` (
      `id` int(11) NOT NULL AUTO_INCREMENT,
      `name` varchar(255) DEFAULT NULL,
      `email` varchar(255) DEFAULT NULL,
      `created_at` datetime NOT NULL,
      `updated_at` datetime NOT NULL,
      `password_digest` varchar(255) DEFAULT NULL,
      `remember_digest` varchar(255) DEFAULT NULL,
      PRIMARY KEY (`id`),
      UNIQUE KEY `index_users_on_email` (`email`) USING BTREE
    )")

    client.query("ALTER TABLE common CHANGE `id` `id` INT NOT NULL AUTO_INCREMENT")
    client.query("ALTER TABLE common CHANGE recurring_invoice_id recurring_invoice_id INT")
    client.query("ALTER TABLE common CHANGE series_id series_id INT")
    client.query("ALTER TABLE common CHANGE customer_id customer_id INT")
    client.query("ALTER TABLE common CHANGE invoicing_address invoicing_address TEXT")
    client.query("ALTER TABLE common CHANGE shipping_address shipping_address TEXT")
    client.query("ALTER TABLE common CHANGE terms terms TEXT")
    client.query("ALTER TABLE common CHANGE notes notes TEXT")
    client.query("ALTER TABLE common CHANGE base_amount base_amount DECIMAL(53, 15) DEFAULT 0")
    client.query("ALTER TABLE common CHANGE discount_amount discount_amount DECIMAL(53, 15) DEFAULT 0")
    client.query("ALTER TABLE common CHANGE net_amount net_amount DECIMAL(53, 15) DEFAULT 0")
    client.query("ALTER TABLE common CHANGE gross_amount gross_amount DECIMAL(53, 15) DEFAULT 0")
    client.query("ALTER TABLE common CHANGE paid_amount paid_amount DECIMAL(53, 15) DEFAULT 0")
    client.query("ALTER TABLE common CHANGE tax_amount tax_amount DECIMAL(53, 15) DEFAULT 0")
    client.query("ALTER TABLE common CHANGE closed paid TINYINT(1) DEFAULT 0")
    client.query("ALTER TABLE common CHANGE customer_name name VARCHAR(100)")
    client.query("ALTER TABLE common CHANGE customer_identification identification VARCHAR(50)")
    client.query("ALTER TABLE common CHANGE customer_email email VARCHAR(100)")
    client.query("ALTER TABLE common DROP last_execution_date")
    client.query("ALTER TABLE common ADD deleted_at datetime DEFAULT NULL")
    client.query("ALTER TABLE common ADD template_id INT DEFAULT NULL")
    client.query("ALTER TABLE common ADD meta_attributes TEXT")
    client.query("update common set draft=0 where type='RecurringInvoice'")

    client.query("ALTER TABLE customer CHANGE `id` `id` INT NOT NULL AUTO_INCREMENT")
    client.query("ALTER TABLE customer CHANGE invoicing_address invoicing_address TEXT")
    client.query("ALTER TABLE customer CHANGE shipping_address shipping_address TEXT")
    client.query("ALTER TABLE customer ADD deleted_at datetime DEFAULT NULL")
    client.query("ALTER TABLE customer ADD meta_attributes TEXT")


    client.query("ALTER TABLE item CHANGE `id` `id` INT NOT NULL AUTO_INCREMENT")
    client.query("ALTER TABLE item CHANGE common_id common_id INT")
    client.query("ALTER TABLE item CHANGE product_id product_id INT")

    client.query("ALTER TABLE item DROP INDEX desc_idx")
    client.query("ALTER TABLE item CHANGE description description VARCHAR(20000) COLLATE utf8_unicode_ci DEFAULT NULL")
    client.query("ALTER TABLE item ADD deleted_at datetime DEFAULT NULL")
    client.query("ALTER TABLE item ADD INDEX desc_idx (description(255)) USING BTREE")

    client.query("ALTER TABLE item_tax CHANGE item_id item_id INT")
    client.query("ALTER TABLE item_tax CHANGE tax_id tax_id INT")

    client.query("ALTER TABLE payment CHANGE `id` `id` BIGINT(20) NOT NULL AUTO_INCREMENT")
    client.query("DELETE FROM payment WHERE invoice_id IS NULL")
    client.query("ALTER TABLE payment CHANGE invoice_id invoice_id BIGINT(20) NOT NULL")
    client.query("ALTER TABLE payment CHANGE notes notes TEXT")

    client.query("ALTER TABLE payment ADD created_at datetime")
    client.query("ALTER TABLE payment ADD updated_at datetime")
    client.query("ALTER TABLE payment ADD deleted_at datetime DEFAULT NULL")
    current_date = DateTime.current.strftime('%Y/%m/%d %H:%M:%S')
    client.query("UPDATE payment SET created_at = '" << current_date << "', updated_at = '" << current_date << "'")
    client.query("ALTER TABLE payment CHANGE created_at created_at datetime NOT NULL")
    client.query("ALTER TABLE payment CHANGE updated_at updated_at datetime NOT NULL")
    client.query("DELETE FROM payment WHERE amount IS NULL")

    client.query("ALTER TABLE product CHANGE `id` `id` INT NOT NULL AUTO_INCREMENT")
    client.query("ALTER TABLE product CHANGE description description TEXT")
    client.query("ALTER TABLE product ADD deleted_at datetime DEFAULT NULL")

    client.query("DROP TABLE property")
    client.query("CREATE TABLE `settings` (
      `id` int(11) NOT NULL AUTO_INCREMENT,
      `var` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
      `value` text COLLATE utf8_unicode_ci,
      `thing_id` int(11) DEFAULT NULL,
      `thing_type` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,
      `created_at` datetime DEFAULT NULL,
      `updated_at` datetime DEFAULT NULL,
      PRIMARY KEY (`id`),
      UNIQUE KEY `index_settings_on_thing_type_and_thing_id_and_var` (`thing_type`,`thing_id`,`var`)
    ) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;")

    client.query("ALTER TABLE series CHANGE `id` `id` INT NOT NULL AUTO_INCREMENT")
    client.query("ALTER TABLE series CHANGE first_number next_number INT(11) DEFAULT '1'")
    client.query("ALTER TABLE series ADD COLUMN `default` TINYINT(1) DEFAULT FALSE ")
    client.query("ALTER TABLE series ADD deleted_at datetime DEFAULT NULL")


    # Get max invoice number for each series and set the series next_number
    # field accordingly.
    series_info = client.query("SELECT `series_id`, MAX(`number`) AS `current_number` FROM `common` WHERE `type` = 'Invoice' AND `series_id` IS NOT NULL GROUP BY `series_id`")
    series_info.each do |info|
      series_id = info['series_id']
      next_number = info['current_number'] + 1
      client.query("UPDATE `series` SET `next_number` = #{next_number} WHERE `id` = #{series_id};")
    end

    # Tags

    client.query("ALTER TABLE `tag` CHANGE `id` `id` INT NOT NULL AUTO_INCREMENT")
    client.query("ALTER TABLE `tag` CHANGE `name` `name` VARCHAR(255) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL")
    client.query("ALTER TABLE `tag` DROP `is_triple`")
    client.query("ALTER TABLE `tag` DROP `triple_namespace`")
    client.query("ALTER TABLE `tag` DROP `triple_key`")
    client.query("ALTER TABLE `tag` DROP `triple_value`")
    client.query("ALTER TABLE `tag` ADD `taggings_count` INT(11)  NULL  DEFAULT '0'  AFTER `name`")
    client.query("ALTER TABLE `tag` DROP INDEX `name_idx`")
    client.query("ALTER TABLE `tag` ADD UNIQUE INDEX `index_tags_on_name` (`name`)")
    client.query("RENAME TABLE `tag` TO `tags`")

    # Taggings

    client.query("ALTER TABLE `tagging` CHANGE `id` `id` INT NOT NULL AUTO_INCREMENT")
    client.query("ALTER TABLE `tagging` CHANGE `tag_id` `tag_id` INT")
    client.query("ALTER TABLE `tagging` CHANGE `taggable_id` `taggable_id` INT")
    client.query("ALTER TABLE `tagging` CHANGE `taggable_model` `taggable_type` VARCHAR(255)  CHARACTER SET utf8  COLLATE utf8_unicode_ci  NULL  DEFAULT NULL")
    client.query("ALTER TABLE `tagging` ADD `tagger_id` INT(11)  NULL  DEFAULT NULL  AFTER `taggable_id`")
    client.query("ALTER TABLE `tagging` ADD `tagger_type` VARCHAR(255)  CHARACTER SET utf8  COLLATE utf8_unicode_ci  NULL  DEFAULT NULL")
    client.query("ALTER TABLE `tagging` ADD `context` VARCHAR(128)  NULL  DEFAULT NULL  AFTER `tagger_type`")
    client.query("ALTER TABLE `tagging` ADD `created_at` DATETIME  NULL  AFTER `context`")
    client.query("ALTER TABLE `tagging` DROP INDEX `tag_idx`")
    client.query("ALTER TABLE `tagging` DROP INDEX `taggable_idx`")
    client.query("ALTER TABLE `tagging` ADD UNIQUE INDEX `taggings_idx` (`tag_id`, `taggable_id`, `taggable_type`, `context`, `tagger_id`, `tagger_type`)")
    client.query("ALTER TABLE `tagging` ADD INDEX `index_taggings_on_taggable_id_and_taggable_type_and_context` (`taggable_id`, `taggable_type`, `context`)")
    client.query("RENAME TABLE `tagging` TO `taggings`")

    client.query("UPDATE `taggings` SET `taggable_type` = 'Common', `context` = 'tags', `created_at` = '" << DateTime.current.strftime('%Y/%m/%d %H:%M:%S') << "'")

    # Update taggings_count

    tags = client.query("SELECT `tag_id` AS `id`, COUNT(`tag_id`) AS `taggings_count` FROM `taggings` GROUP BY `tag_id`")
    tags.each do |tag|
       id = tag['id']
       taggings_count = tag['taggings_count']
       client.query("UPDATE `tags` SET `taggings_count` = #{taggings_count} WHERE `id` = #{id}")
    end

    # Taxes

    client.query("ALTER TABLE tax CHANGE `id` `id` INT NOT NULL AUTO_INCREMENT")
    client.query("ALTER TABLE tax CHANGE `is_default` `default` TINYINT(1) DEFAULT false")
    client.query("ALTER TABLE tax ADD deleted_at datetime DEFAULT NULL")

    # Templates

    client.query("TRUNCATE TABLE template")
    client.query("ALTER TABLE template CHANGE `id` `id` INT NOT NULL AUTO_INCREMENT")
    client.query("ALTER TABLE template CHANGE template template TEXT")
    client.query("ALTER TABLE template DROP `slug`")
    client.query("ALTER TABLE template ADD COLUMN `default` TINYINT(1) DEFAULT false")
    client.query("ALTER TABLE template ADD deleted_at datetime DEFAULT NULL")

    # Table renaming according to rails convention
    client.query("RENAME TABLE common TO commons")
    client.query("RENAME TABLE customer TO customers")
    client.query("RENAME TABLE item TO items")
    client.query("RENAME TABLE payment TO payments")
    client.query("RENAME TABLE product TO products")
    client.query("RENAME TABLE template TO templates")
    client.query("RENAME TABLE tax TO taxes")
    client.query("RENAME TABLE item_tax TO items_taxes")

    # Create webhooks table
    client.query("CREATE TABLE `webhook_logs` (
      `id` int(11) NOT NULL AUTO_INCREMENT,
      `level` varchar(255) NOT NULL DEFAULT 'info',
      `message` varchar(255) DEFAULT NULL,
      `event` varchar(255) NOT NULL,
      `created_at` datetime NOT NULL,
      `updated_at` datetime NOT NULL,
      PRIMARY KEY (`id`),
      KEY `index_webhook_logs_on_event` (`event`) USING BTREE
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci")

    # Create migrations table
    client.query("CREATE TABLE `schema_migrations` (
       `version` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
       UNIQUE KEY `unique_schema_migrations` (`version`)
       ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci")

    # Load data seed
    Rake::Task['db:seed'].invoke

    # Iterate saving each invoice to update status
    Invoice.all.each {|invoice| invoice.save}
  end
end
