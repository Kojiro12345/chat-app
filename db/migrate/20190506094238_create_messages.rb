class CreateMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :messages do |t|
      t.references :room, foreign_key: true
      t.integer :speaker_id
      t.boolean :is_read
      t.text :body

      t.timestamps
    end
  end
end
