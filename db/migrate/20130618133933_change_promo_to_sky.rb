class ChangePromoToSky < ActiveRecord::Migration
  def self.up
    add_column :promos, :promo_type_id, :integer
    add_column :promos, :season_start, :string
    add_column :promos, :season_end, :string
    add_column :promos, :episode_start, :string
    add_column :promos, :episode_end, :string
  end

  def self.down
    remove_column :promos, :promo_type_id, :integer
    remove_column :promos, :season_start, :string
    remove_column :promos, :season_end, :string
    remove_column :promos, :episode_start, :string
    remove_column :promos, :episode_end, :string
  end
end
