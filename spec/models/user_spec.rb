require 'rails_helper'

RSpec.describe User, :type => :model do

  it "is not valid without a name" do
    user = User.new(email: 'user@example.com', password: 'testpwd')
    expect(user).not_to be_valid
  end

  it "is not valid without an email" do
    user = User.new(name: 'A User', password: 'testpwd')
    expect(user).not_to be_valid
  end

  it "is not valid without a password" do
    user = User.new(name: 'A User', email: 'user@example.com')
    expect(user).not_to be_valid
  end

  it "is not valid with an invalid password" do
    user = User.new(name: 'A User', email: 'user@example.com', password: 'test')
    expect(user).not_to be_valid
  end

  it "can be authenticated via token" do
    user = User.create(name: 'A User', email: 'user@example.com', password: 'testpwd')
    user.remember

    token = user.remember_token
    expect(user.authenticated? token).to be true
  end

  it "does not authenticate with an invalid remember token" do
    user = User.create(name: 'A User', email: 'user@example.com', password: 'testpwd')
    user.remember

    expect(user.authenticated? 'bad token').to be false
  end
end
