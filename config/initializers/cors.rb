Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    configured_origins = ENV.fetch(
      "CORS_ORIGINS",
      "http://localhost:3000,http://localhost:5173,http://localhost:8080"
    ).split(",")

    development_origins = if Rails.env.development?
      [
        /\Ahttp:\/\/localhost:\d+\z/,
        /\Ahttp:\/\/127\.0\.0\.1:\d+\z/
      ]
    else
      []
    end

    origins(*(configured_origins + development_origins))

    resource "*",
      headers: :any,
      expose: ["Authorization"],
      methods: %i[get post put patch delete options head]
  end
end
