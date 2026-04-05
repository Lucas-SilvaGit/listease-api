class JsonWebToken
  SECRET_KEY = ENV.fetch("JWT_SECRET", "development-secret-change-me")

  def self.encode(payload = nil, expires_at: 30.days.from_now, **extra_payload)
    merged_payload = (payload || {}).merge(extra_payload)
    JWT.encode(merged_payload.merge(exp: expires_at.to_i), SECRET_KEY, "HS256")
  end

  def self.decode(token)
    body, = JWT.decode(token, SECRET_KEY, true, algorithm: "HS256")
    body
  end
end
