require 'rails_helper'

RSpec.describe Space, type: :model do
  it "Can't be created privately on users without private access" do
    user = FactoryGirl.create(:user)
    user.has_private_access = false
    user.save
    expect(user.spaces.create(is_private: true).save).to eq false
  end

  it "Can be created privately on users with private access" do
    user = FactoryGirl.create(:user)
    user.has_private_access = true
    user.private_access_count = 3
    user.save
    expect(user.spaces.create(is_private: true).save).to eq true
  end

  it "Can be created publicly on any user" do
    user = FactoryGirl.create(:user)
    user.save
    expect(user.spaces.create().save).to eq true

    user = FactoryGirl.create(:user)
    user.has_private_access = true
    user.private_access_count = 3
    user.save
    expect(user.spaces.create().save).to eq true
  end

end
