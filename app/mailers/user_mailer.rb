class UserMailer < ActionMailer::Base
  default from: "monbattle@monbattle.com"

  def send_code_email(email)
    mail( :to => email,
    :subject => 'You motherfucker' )
  end

end
