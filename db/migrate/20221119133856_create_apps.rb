class CreateApps < ActiveRecord::Migration[7.0]
  def change
    create_table :apps do |t|
      t.string :token
      t.string :name, null: false, index: { unique: true }

      t.timestamps
    end
  end
end
