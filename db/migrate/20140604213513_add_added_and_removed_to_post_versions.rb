class AddAddedAndRemovedToPostVersions < ActiveRecord::Migration
  def change
    execute("set statement_timeout = 0")
    add_column :post_versions, :added, :text
    add_column :post_versions, :removed, :text
    add_column :post_versions, :added_index, "tsvector"
    add_column :post_versions, :removed_index, "tsvector"
    execute "CREATE INDEX index_post_versions_on_added_index ON post_versions USING gin (added_index) WHERE added_index IS NOT NULL"
    execute "CREATE INDEX index_post_versions_on_removed_index ON post_versions USING gin (removed_index) WHERE removed_index IS NOT NULL"
    execute "CREATE TRIGGER trigger_post_versions_on_added_index_update BEFORE INSERT OR UPDATE ON post_versions FOR EACH ROW EXECUTE PROCEDURE tsvector_update_trigger('added_index', 'public.danbooru', 'added')"
    execute "CREATE TRIGGER trigger_post_versions_on_removed_index_update BEFORE INSERT OR UPDATE ON post_versions FOR EACH ROW EXECUTE PROCEDURE tsvector_update_trigger('removed_index', 'public.danbooru', 'removed')"
  end
end
