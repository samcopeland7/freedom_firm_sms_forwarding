module Webhookable
  extend ActiveSupport::Concern

  def render_twiml(response)
    render xml: response
  end

  def twilio_account_sid
    Rails.application.secrets.twilio_account_sid
  end

  def twilio_auth_token
    Rails.application.secrets.twilio_auth_token
  end

end
