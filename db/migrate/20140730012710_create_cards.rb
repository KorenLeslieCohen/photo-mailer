class CreateCards < ActiveRecord::Migration
  def change
    create_table :cards do |t|
      t.string :sender_email
      t.string :recipient_email
      t.string :sender_name
      t.string :recipient_name
      t.string :path
      t.text :message

      t.timestamps
    end
  end
end
