class Twilio::SwitchboardController < ApplicationController
  include Webhookable

  skip_before_action :verify_authenticity_token

  def reroute
    redirect_to controller: 'messages', action: 'forward', params: allow_params
  end

  private

  def allow_params
    params.permit(:From, :FromState)
  end
end
