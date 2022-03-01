FactoryBot.define do
  factory :task do
    name { 'test_title' }
    explanation { 'test_explanation' }
    deadline { '2025/05/11/11/12' }
    progress { '着手中' }
    priority { '低' }
  end

  factory :second_task, class: Task do
    name { 'Factoryで作ったデフォルトの名前' }
    explanation { 'Factoryで作ったデフォルトの説明'}
    deadline { '2024/05/11/11/12' }
    progress { '未着手' }
    priority { '中' }
  end

  factory :third_task, class: Task do
    name { '掃除' }
    explanation { '事務所の整理' }
    deadline { '2021/12/25/01/30' }
    progress { '完了' }
    priority { '高' }
  end

  factory :fourth_task, class: Task do
    name { 'rspec' }
    explanation { 'rspecの勉強' }
    deadline { '2024/10/01/01/30' }
    progress { '未着手' }
    priority { '低' }
  end

  factory :fifth_task, class: Task do
    name { 'test' }
    explanation { 'testの勉強' }
    deadline { '2020/11/09/10/29' }
    progress { '完了' }
    priority { '中' }
  end
end