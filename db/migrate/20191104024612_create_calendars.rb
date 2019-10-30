class CreateCalendars < ActiveRecord::Migration[6.0]
  def change
    create_table :calendars do |t|
      t.datetime :day
      t.string :tag
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
    add_index :calendars, [:user_id, :created_at]
  end
end
