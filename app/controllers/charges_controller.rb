class ChargesController < ApplicationController
  layout "facebook_landing"


  def new 
  end

  def create
    # Amount in cents
    @amount = params[:donation].gsub(/,/, '').to_s + "00"

    customer = Stripe::Customer.create(
      :email => "example@stripe.com",
      :card => params[:stripeToken]
      )

    charge = Stripe::Charge.create(
      :customer => customer.id,
      :amount => @amount,
      :description => 'Monbattle Stripe customer',
      :currency => 'usd'
      )

    flash[:success] = "Ha! Sucker!"
    redirect_to root_path

  rescue Stripe::CardError => e 
    flash[:error] = e.message
    redirect_to charges_path
  end

end
