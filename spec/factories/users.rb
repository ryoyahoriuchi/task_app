FactoryBot.define do
  factory :user do
    name { "MyString" }
    email { "MyString" }
    password_digest { "MyString" }
  end

  factory :second_user, class: User do
    name { "test" }
    email { "test@mail.com" }
    password { "password" }
    admin { false }
  end

  factory :third_user, class: User do
    name { "master" }
    email { "master@mail.com" }
    password { "password" }
    admin { true }
  end

end
