module Api
  module V1
    class AuthController < ApplicationController
      def google
        result = Auth::GoogleSignInService.new(id_token: auth_params[:id_token]).call

        render_auth_response(result.user, :created)
      rescue Auth::GoogleSignInService::InvalidTokenError => e
        render json: { error: e.message }, status: :unauthorized
      end

      def register
        user = User.new(register_params)

        if user.save
          render_auth_response(user, :created)
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def login
        user = User.find_by(email: login_params[:email].to_s.downcase.strip)

        if user&.authenticate(login_params[:password])
          render_auth_response(user)
        else
          render json: { error: "Invalid email or password" }, status: :unauthorized
        end
      end

      private

      def render_auth_response(user, status = :ok)
        render json: {
          token: JsonWebToken.encode(user_id: user.id),
          user: UserSerializer.new(user).as_json
        }, status:
      end

      def auth_params
        params.fetch(:auth, params).permit(:id_token)
      end

      def register_params
        params.fetch(:auth, params).permit(:name, :email, :password, :password_confirmation).tap do |safe_params|
          safe_params[:email] = safe_params[:email].to_s.downcase.strip
        end
      end

      def login_params
        params.fetch(:auth, params).permit(:email, :password)
      end
    end
  end
end
