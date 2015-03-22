# This migration comes from home_page_engine (originally 20150315082328)
class CreatePageModulesAndPageModuleCollections < ActiveRecord::Migration
  def change
    create_table :page_module_collections do |t|
      t.string :slug
      t.string :slug_stub
      t.string :title
      t.timestamps
    end
    
    add_index :page_module_collections, :slug, unique: true
    add_index :page_module_collections, :slug_stub, unique: true
    
    create_table :page_module_collections_modules do |t|
      t.integer :collection_id
      t.integer :position
      t.integer :module_id
      t.timestamps
    end
    
    add_index :page_module_collections_modules, [:collection_id, :position, :module_id], unique: true, name: 'uniq_page_module_collections_module'
    
    create_table :page_modules do |t|
      t.string :slug
      t.string :slug_stub
      t.string :title
      t.string :description
      t.string :partial_path
      t.text :content, limit: 65535
      t.text :data, limit: 16777215
      t.string :moduleable_type
      t.integer :moduleable_id
      t.datetime :published_from
      t.datetime :published_until
      t.timestamps
    end
    
    add_index :page_modules, :slug, unique: true
    add_index :page_modules, :slug_stub
    add_index :page_modules, [:moduleable_type, :moduleable_id]
    add_index :page_modules, :published_from
    add_index :page_modules, :published_until
  end
end
