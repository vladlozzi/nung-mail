class ApplicationController < ActionController::Base
  before_action :authenticate

  private

  def authenticate
    authenticate_or_request_with_http_basic("NUNG Mail") do |username, password|
      ActiveSupport::SecurityUtils.secure_compare(username, http_auth.fetch(:user)) &
        ActiveSupport::SecurityUtils.secure_compare(password, http_auth.fetch(:password))
    end
  end

  def http_auth
    Rails.application.credentials.http_auth ||
      raise("Додайте http_auth.user і http_auth.password у credentials (bin/rails credentials:edit)")
  end
end
