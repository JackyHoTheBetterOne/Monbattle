Rails.configuration.stripe = {
  :publishable_key => Rails.application.secrets.stripe_publishable_key,
  :secret_key => Rails.application.secrets.stripe_secret
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]