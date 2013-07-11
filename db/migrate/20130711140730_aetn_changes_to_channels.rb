class AetnChangesToChannels < ActiveRecord::Migration
  def self.up
    remove_column :channels, :press_code
    remove_column :channels, :playlist_code
    remove_column :channels, :language_id
    remove_column :channels, :domain
    remove_column :channels, :path
    remove_column :channels, :bss_name
    remove_column :channels, :hd
    remove_column :channels, :prefix
    remove_column :channels, :logo_filename
    remove_column :channels, :circle_logo
    remove_column :channels, :encoding
    remove_column :channels, :has_dynamic_branding
    add_column :channels, :code, :string
  end

  def self.down
    add_column :channels, :press_code, :string
    add_column :channels, :playlist_code, :string
    add_column :channels, :language_id, :integer
    add_column :channels, :domain, :string
    add_column :channels, :path, :string
    add_column :channels, :bss_name, :string
    add_column :channels, :hd, :boolean
    add_column :channels, :prefix, :string
    add_column :channels, :logo_filename, :string
    add_column :channels, :circle_logo, :boolean
    add_column :channels, :encoding, :string
    add_column :channels, :has_dynamic_branding, :boolean
    remove_column :channels, :code
  end
end
