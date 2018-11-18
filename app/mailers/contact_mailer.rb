class ContactMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.contact_mailer.contact_demand.subject
  #
  def contact_demand(data)
    @nom = data[:nom]
    @email = data[:email]
    @message = data[:message]

    mail from: @email, to: 'contact@sensorygarden.be', subject: "Nouvelle demande de contact de #{@nom} !"
  end

  def user_signup(user) 
      @user = user

      mail from: 'noreply@sensorygarden.be', to: @user[:email], subject: "Bienvenue #{@user[:prenom]} !"
  end

  def password_reset(user)
    @user = user

    mail from: 'noreply@sensorygarden.be', to: @user[:email], subject: "Mot de passe oublié sur Sensorygarden.be"
  end
end
