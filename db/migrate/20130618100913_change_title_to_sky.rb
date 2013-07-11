class ChangeTitleToSky < ActiveRecord::Migration
  def self.up
    remove_column :titles, :english
    remove_column :titles, :danish
    remove_column :titles, :swedish
    remove_column :titles, :norwegian
    remove_column :titles, :hungarian
    remove_column :titles, :eop
    add_column :titles, :schedule_title, :string
    add_column :titles, :display_title, :string    
  end

  def self.down
    add_column :titles, :english, :string
    add_column :titles, :danish, :string
    add_column :titles, :swedish, :string
    add_column :titles, :norwegian, :string
    add_column :titles, :hungarian, :string
    add_column :titles, :eop, :boolean
    remove_column :titles, :schedule_title
    remove_column :titles, :display_title  
  end
end

