FactoryBot.define do
  factory :label do
    name { "MyString" }
  end

  factory :second_label, class: Label do
    name { "赤" }
  end

  factory :third_label, class: Label do
    name { "青" }
  end

  factory :fourth_label, class: Label do
    name { "黄" }
  end
end
