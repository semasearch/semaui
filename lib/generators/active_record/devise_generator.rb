def copy_devise_migration
  if (behavior == :invoke && model_exists?) || (behavior == :revoke && migration_exists?(table_name))
    migration_template "migration_existing.rb", "db/migrate/add_devise_to_#{table_name}"
    migration_template "migration_existing.rb", "db/migrate/add_devise_to_#{table_name}.rb"
  else
    migration_template "migration.rb", "db/migrate/devise_create_#{table_name}"
    migration_template "migration.rb", "db/migrate/devise_create_#{table_name}.rb"
  end
end