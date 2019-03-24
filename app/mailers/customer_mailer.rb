class CustomerMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.customer_mailer.accont_activation.subject
  #
  def accont_activation(customer)
    @customer = customer
    mail to: customer.email, subject: "accont_activation"
  end

  def release_account_lock(customer)
    @customer = customer
    mail to: customer.email, subject: "release_account_lock"
  end
end
