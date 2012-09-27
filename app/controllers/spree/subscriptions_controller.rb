class Spree::SubscriptionsController < Spree::BaseController

  def hominid
    @hominid ||= Hominid::API.new(Spree::Config.get(:mailchimp_api_key))
    #@hominid ||= Hominid::Base.new({ :api_key => Spree::Config.get(:mailchimp_api_key) })
  end

  def create
    @errors = []

    if params[:email].blank?
      @errors << t('missing_email')
    elsif params[:email] !~ /[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}/i
      @errors << t('invalid_email_address')
    else
      begin
        hominid.list_subscribe(Spree::Config.get(:mailchimp_list_id), params[:email])
      rescue
        @errors << "It looks like you're already subscribed"
      end
    end

    if @errors.blank?
      redirect_to :back, :notice => "Thank you. You'll receive a validation email shortly."
    else
      redirect_to :back, :notice => @errors.join(",")
    end

  end
end
