class ApplicationController < ActionController::Base
  include ApplicationHelper

  before_action :set_locale

  protected
    def set_locale
      if params[:locale]
        I18n.locale = params[:locale]
      else
        I18n.locale = cookies[:locale] || I18n.default_locale
      end
    end
end
