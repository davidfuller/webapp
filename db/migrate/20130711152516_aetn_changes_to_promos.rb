class AetnChangesToPromos < ActiveRecord::Migration

  def self.up
    remove_column :promos, :title_id
    remove_column :promos, :promo_type_id
    remove_column :promos, :season_start
    remove_column :promos, :season_end
    remove_column :promos, :episode_start
    remove_column :promos, :episode_end
    add_column :promos, :channel_id, :integer
    add_column :promos, :priority, :string
  end

  def self.down
    add_column :promos, :title_id, :integer
    add_column :promos, :promo_type_id, :integer
    add_column :promos, :season_start, :string
    add_column :promos, :season_end, :string
    add_column :promos, :episode_start, :string
    add_column :promos, :episode_end, :string
    remove_column :promos, :channel_id
    remove_column :promos, :priority
  end
end
