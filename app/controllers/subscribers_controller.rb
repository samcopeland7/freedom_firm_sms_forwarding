class SubscribersController < ApplicationController
  def index
    @subscribers = Subscriber.all
  end

  def show
    @subscriber = Subcscriber.find(params[:id])
  end

  def create
    @subscriber = Subscriber.create!(subcriber_params)
    redirect_to action: 'messages#welcome'
  end

  def update
    @subscriber = Subcscriber.update!(subscriber_params)
  end

  def destroy
    Subscriber.find(params[:id]).destroy!
  end

  private

  def subcriber_params
    params.permit(:name, :email, :phone_number, :state)
  end
end
