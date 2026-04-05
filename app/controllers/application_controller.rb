class ApplicationController < ActionController::API
  around_action :with_current_attributes

  rescue_from ActiveRecord::RecordNotFound do
    render json: { error: "Resource not found" }, status: :not_found
  end

  private

  def with_current_attributes
    Current.reset
    yield
  ensure
    Current.reset
  end
end
