class UserSerializer
  def initialize(user)
    @user = user
  end

  def as_json(*)
    {
      id: user.id,
      name: user.name,
      email: user.email,
      avatar_url: user.avatar_url
    }
  end

  private

  attr_reader :user
end
