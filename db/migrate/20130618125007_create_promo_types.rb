class CreatePromoTypes < ActiveRecord::Migration
  def self.up
    create_table :promo_types do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :promo_types
  end
end
