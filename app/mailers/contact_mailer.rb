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
end
