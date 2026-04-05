module Auth
  class GoogleSignInService
    class InvalidTokenError < StandardError; end

    Result = Struct.new(:user, keyword_init: true)

    def initialize(id_token:)
      @id_token = id_token
    end

    def call
      payload = verify_token!
      user = User.find_or_initialize_by(email: payload["email"].to_s.downcase)
      user.email = payload["email"]
      user.name = payload["name"].presence || payload["email"].split("@").first
      user.avatar_url = payload["picture"]
      user.google_uid = payload["sub"]
      user.save!

      Result.new(user:)
    end

    private

    attr_reader :id_token

    def verify_token!
      raise InvalidTokenError, "Google idToken is required" if id_token.blank?

      Google::Auth::IDTokens.verify_oidc(id_token, aud: ENV["GOOGLE_CLIENT_ID"].presence)
    rescue StandardError
      raise InvalidTokenError, "Invalid Google token"
    end
  end
end
