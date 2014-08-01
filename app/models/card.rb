class Card < ActiveRecord::Base

has_attached_file :photo, :storage => :s3, :hash_secret => "longSecretString", :path => ":hash", :bucket => "FlatironPostcard", :styles => { :thumb => "1024x768"}, :default_style => :thumb, :s3_protocol => "https"

validates :photo, :attachment_presence => true


validates_with AttachmentSizeValidator, :attributes => :photo, :less_than => 3.megabytes
validates_attachment_content_type :photo, :content_type => /\Aimage\/.*\Z/
validates_presence_of :sender_email, :sender_name, :recipient_name, :recipient_email, :message

def s3_credentials
  { :access_key_id => AWS_ACCESS_KEY_ID, :secret_access_key => AWS_SECRET_ACCESS_KEY}
end

def mail (html_card)
    m = Mandrill::API.new
    message = {  
     :subject=> "Hey, #{self.recipient_name}! #{self.sender_name} sent you a FlatironPostcard!",  
     :from_name=> self.sender_name,
     :text=>"You've received a postcard from FlatironPostcard, but you have HTML emails disabled. Sorry!",  
     :to=>[  
       {  
         :email=> self.recipient_email,  
         :name=> self.recipient_name 
       },
       {  
         :email=> self.sender_email,  
         :name=> self.sender_name 
       } 
     ],  
     :html=>html_card,  
     :from_email=> self.sender_email  
    }  
    sending = m.messages.send message
end
 


  
end
