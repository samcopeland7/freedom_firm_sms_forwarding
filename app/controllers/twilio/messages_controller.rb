class Twilio::MessagesController < ApplicationController
  include Webhookable
  skip_before_action :verify_authenticity_token

  def handle
    if (user = User.find_by(phone_number: params[:From]))
      return unless user.admin?
      @client = Twilio::REST::Client.new ENV.fetch('TWILIO_ACCOUNT_SID'),
                                         ENV.fetch('TWILIO_AUTH_TOKEN')
      Subscriber.all.each do |sub|
        @client.messages.create(
          from: ENV.fetch('TWILIO_PHONE_NUMBER'),
          to: sub.phone_number,
          body: params[:Body]
        )
      end
    else
      unless (@subscriber = Subscriber.find_by(phone_number: params[:From]))
        @subscriber = Subscriber.create!(subscriber_params)
        @new_subscriber = true
      end

      if params[:Body].match?(/stop/i)
        response_body = 'You have unsubscribed from Freedom Firm updates. You will no longer ' \
          'receive future prayer updates.'
        @subscriber.destroy!
      elsif @new_subscriber
        response_body = 'You will now receive prayer updates for Freedom Firm. Reply STOP ' \
          'to no longer receive messages.' 
      else
        response_body = 'You are already subscribed to updates from Freedom Firm. Reply STOP '\
          'to no longer receive messages.'
      end

      message = Twilio::TwiML::MessagingResponse.new do |r|
        r.message(
          body: response_body,
          from: ENV.fetch('TWILIO_PHONE_NUMBER'),
          to: @subscriber.phone_number
        )
      end

      render_twiml message
    end
  end

  def help
  end

  def stop
  end

  def subscribe
    Subscriber.create!(subscriber_params)
    render status: 200
  end

  def forward
    render plain: params
  end

  private

  def subscriber_params
    sub_params = params.permit(:email, :phone_number, :state)
    sub_params[:phone_number] = params[:From]
    sub_params[:state] = params[:FromState]
    sub_params
  end
end
