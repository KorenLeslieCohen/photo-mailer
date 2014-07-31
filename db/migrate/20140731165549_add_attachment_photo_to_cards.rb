class AddAttachmentPhotoToCards < ActiveRecord::Migration
  def self.up
    change_table :cards do |t|
      t.attachment :photo
    end
  end

  def self.down
    remove_attachment :cards, :photo
  end
end
