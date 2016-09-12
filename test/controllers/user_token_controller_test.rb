require 'test_helper'

class UserTokenControllerTest < ActionDispatch::IntegrationTest
  test "should create token on valid credentials" do
    params = {
      auth: {
        login: "user1",
        password: "password1"
      }
    }
    post knock_auth_token_url, params: params.to_json, headers: {'Accept' => "application/json", 'Content-Type' => 'application/json'}
    assert_response 201

    token = JSON.parse(@response.body)
    assert_not_nil token['jwt']
  end

  test "shouldn't create token on invalid credentials" do
    params = {
      auth: {
        login: "user1",
        password: "password2"
      }
    }
    post knock_auth_token_url, params: params.to_json, headers: {'Accept' => "application/json", 'Content-Type' => 'application/json'}
    assert_response 404
  end

end
