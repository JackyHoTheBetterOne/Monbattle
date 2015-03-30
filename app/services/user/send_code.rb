require 'mandrill'

class User::SendCode
  include Virtus.model
  attribute :users, Array
  attribute :codes, Array
  attribute :to, Array
  attribute :merge_vars, Array

  def construct
    self.users.each do |user|
      b = {}
      b[:email] = user[:email]
      b[:name] = user[:first_name]
      self.to.push(b)
    end

    self.users.each do |user|
      b = {}
      b[:rcpt] = user[:email]
      b[:vars] = []
      b[:vars] << {name: "first_name", content: user[:first_name]}
      b[:vars] << {name: "last_name", content: user[:last_name]}
      b[:vars] << {name: "sent_code", content: self.codes[self.users.index(user)].code}
      self.merge_vars.push(b)
    end
  end

  def call
    viewer = ApplicationController.new
    man = Mandrill::API.new
    message = {
      subject: "Here's the code, bitch",
      from_name: "Cock sucker",
      from_email: "code_sent@cocksuck.com",
      to: self.to,
      html: viewer.render_to_string('user_mailer/mandrill', layout: false),
      merge_vars: self.merge_vars,
      preserve_recepients: false
    }

    sending = man.messages.send message
    p "//////////////////////////////////////////////////////////////"
    p sending
    p "/////////////////////////////////////////////////////////////"
  end

end