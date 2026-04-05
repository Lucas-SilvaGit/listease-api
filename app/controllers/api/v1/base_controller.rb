module Api
  module V1
    class BaseController < ApplicationController
      before_action :authenticate_user!

      private

      def authenticate_user!
        token = request.headers["Authorization"].to_s.remove(/^Bearer\s+/)
        payload = JsonWebToken.decode(token)
        @current_user = User.find_by(id: payload["user_id"])
        raise ActiveRecord::RecordNotFound unless @current_user

        Current.user = @current_user
      rescue JWT::DecodeError, ActiveRecord::RecordNotFound
        render json: { error: "Unauthorized" }, status: :unauthorized
      end

      def current_user
        @current_user
      end
    end
  end
end
