class Twilio::MessagesController < ApplicationController
  include Webhookable
  skip_before_action :verify_authenticity_token

  def welcome
    unless (subscriber = Subscriber.find_by(phone_number: params[:From]))
      subscriber = Subscriber.create!(subscriber_params)
    end

    message = Twilio::TwiML::MessagingResponse.new do |r|
      r.message(
        body: 'You will now receive prayer updates for Freedom Firm. Reply HELP for help. Reply STOP to no longer receive messages.',
        from: ENV.fetch('TWILIO_PHONE_NUMBER'),
        to: subscriber.phone_number
      )
    end

    render_twiml message
  end

  def help
  end

  def stop
  end

  def subscribe
    Subscriber.create!(subscriber_params)
  end

  def forward
  end

  private

  def subscriber_params
    sub_params = params.permit(:email, :phone_number, :state)
    sub_params[:phone_number] = params[:From]
    sub_params[:state] = params[:FromState]
    sub_params
  end
end
