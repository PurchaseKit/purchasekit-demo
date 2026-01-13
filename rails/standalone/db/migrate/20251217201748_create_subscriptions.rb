class CreateSubscriptions < ActiveRecord::Migration[8.0]
  def change
    create_table :subscriptions do |t|
      t.references :user, null: false, foreign_key: true
      t.string :processor_id, null: false
      t.string :store, null: false
      t.string :store_product_id
      t.string :status, null: false, default: "active"
      t.datetime :current_period_start
      t.datetime :current_period_end
      t.datetime :ends_at
      t.timestamps
    end

    add_index :subscriptions, :processor_id, unique: true
    add_index :subscriptions, :status
  end
end
