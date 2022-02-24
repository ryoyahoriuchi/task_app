FactoryBot.define do
  factory :task do
    name { 'test_title' }
    explanation { 'test_explanation' }
    deadline { '2025/05/11/11/12' }
  end

  factory :second_task, class: Task do
    name { 'Factoryで作ったデフォルトの名前' }
    explanation { 'Factoryで作ったデフォルトの説明'}
    deadline { '2024/05/11/11/12' }
  end
end