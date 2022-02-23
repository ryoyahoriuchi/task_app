FactoryBot.define do
  factory :task do
    name { 'test_title' }
    explanation { 'test_explanation' }
  end

  factory :second_task, class: Task do
    name { 'Factoryで作ったデフォルトの名前' }
    explanation { 'Factoryで作ったデフォルトの説明'}
  end
end