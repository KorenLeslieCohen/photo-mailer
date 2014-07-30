class UserMailer < ActionMailer::Base
  default from: "koren.cohen@gmail.com"

  # def welcome_email(user)
  #   @user = user
  #   @url  = 'http://example.com/login'
  #   mail(to: @user.email, subject: 'Welcome to My Awesome Site')
  # end

  def welcome_email(card)
    @card = card
    @url  = 'http://example.com/login'
    mail(to: @card.recipient_email, subject: 'Welcome to My Awesome Site')
  end
end
