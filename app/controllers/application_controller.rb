# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :set_locale

  def set_locale
    I18n.locale = if params[:locale]
                    params[:locale]
                  elsif cookies[:locale].present?
                    cookies[:locale]
                  else
                    I18n.default_locale
                  end

    cookies[:locale] = I18n.locale
  end

  def default_url_options
    {}
  end
end
