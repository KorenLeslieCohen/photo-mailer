class Card < ActiveRecord::Base
  validates_presence_of :sender_email, :sender_name, :recipient_name, :recipient_email

  
end
