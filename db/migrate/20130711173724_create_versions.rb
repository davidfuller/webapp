class CreateVersions < ActiveRecord::Migration
  def self.up
    create_table :versions do |t|
      t.string :note
      t.date :prog_first_tx
      t.date :first_use
      t.date :last_use
      t.string :tx_info
      t.string :name
      t.integer :duration
      t.string :sponsor
      t.boolean :uk_premiere
      t.integer :promo_id
      t.integer :producer_id

      t.timestamps
    end
  end

  def self.down
    drop_table :versions
  end
end
