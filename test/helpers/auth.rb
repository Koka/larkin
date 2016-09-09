def authenticate(user)
  token = Knock::AuthToken.new(payload: { sub: user.id }).token
  {"Authorization" => "Bearer #{token}"}
end
