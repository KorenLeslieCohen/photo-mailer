class Card < ActiveRecord::Base

has_attached_file :photo, :storage => :s3, :hash_secret => "longSecretString", :path => ":hash", :bucket => "FlatironPostcard"

validates :photo, :attachment_presence => true

validates_with AttachmentPresenceValidator, :attributes => :photo
validates_with AttachmentSizeValidator, :attributes => :photo, :less_than => 3.megabytes
validates_attachment_content_type :photo, :content_type => /\Aimage\/.*\Z/
validates_presence_of :sender_email, :sender_name, :recipient_name, :recipient_email, :message

def s3_credentials
  { :access_key_id => AWS_ACCESS_KEY_ID, :secret_access_key => AWS_SECRET_ACCESS_KEY}
end

 


  
end
