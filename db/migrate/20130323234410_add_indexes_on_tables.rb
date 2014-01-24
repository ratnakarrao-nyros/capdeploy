class AddIndexesOnTables < ActiveRecord::Migration
  # The pg_trgm module provides GiST and GIN index operator classes that allow you to create an index
  # over a text column for the purpose of very fast similarity searches.
  # These index types support the above-described similarity operators, and additionally
  # support trigram-based index searches for LIKE and ILIKE queries.
  # (These indexes do not support equality nor simple comparison operators, so you may need a regular B-tree index too.)
  #
  # Generate indexes for these tables :
  # admins, users, contacts, lists, items
  def up
    execute "DROP INDEX index_admins_on_email"
    execute "CREATE INDEX idx_gin_admins_email ON admins USING gin(email gin_trgm_ops)"

    execute "DROP INDEX index_users_on_email"
    execute "CREATE INDEX idx_gin_users_email ON users USING gin(email gin_trgm_ops)"
    execute "CREATE INDEX idx_gin_users_last_sign_in_ip ON users USING gin(last_sign_in_ip gin_trgm_ops)"

    execute "CREATE INDEX idx_gin_contacts_email ON contacts USING gin(email gin_trgm_ops)"
    execute "CREATE INDEX idx_gin_contacts_content ON contacts USING gin(content gin_trgm_ops)"
    execute "CREATE INDEX idx_gin_lists_name ON lists USING gin(name gin_trgm_ops)"
    execute "CREATE INDEX idx_gin_lists_description ON lists USING gin(description gin_trgm_ops)"
    execute "CREATE INDEX idx_gin_items_name ON items USING gin(name gin_trgm_ops)"
    execute "CREATE INDEX idx_gin_items_description ON items USING gin(description gin_trgm_ops)"
  end

  def down
    execute "DROP INDEX idx_gin_admins_email"
    execute "DROP INDEX idx_gin_users_email"
    execute "DROP INDEX idx_gin_contacts_email"
    execute "DROP INDEX idx_gin_contacts_content"
    execute "DROP INDEX idx_gin_lists_name"
    execute "DROP INDEX idx_gin_lists_description"
    execute "DROP INDEX idx_gin_items_name"
    execute "DROP INDEX idx_gin_items_description"
    # restore default btree index
    add_index :users, :email, :unique => true
    add_index :admins, :email, :unique => true
  end
end
