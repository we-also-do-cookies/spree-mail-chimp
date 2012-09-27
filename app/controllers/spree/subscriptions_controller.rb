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
      hominid.list_subscribe(list, params[:email],MailChimpSync::Sync::mc_subscription_opts)
    end

    respond_to do |wants|
      wants.js
    end
  end
end
