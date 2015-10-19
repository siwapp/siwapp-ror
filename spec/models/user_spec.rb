require 'rails_helper'

describe User do
  describe 'valid user' do
    it "user can be created" do
      user = User.new(name:"john Doe", email: "john@doe.com", password: 'passkey',
                      password_confirmation: 'passkey' )
      expect(user).to be_valid
    end
  end
end
