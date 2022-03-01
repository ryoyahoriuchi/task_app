require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'タスクモデル機能', type: :model do
    describe 'バリデーションのテスト' do
      context 'タスクのタイトルが空の場合' do
        it 'バリデーションに引っかかる' do
          task = Task.new(name: '', explanation: '失敗テスト')
          expect(task).not_to be_valid
        end
      end
      context 'タスクの詳細が空の場合' do
        it 'バリデーションに引っかかる' do
          task = Task.new(name: 'task01', explanation: '')
          expect(task).not_to be_valid
        end
      end
      context 'タスクのタイトルと詳細に内容が記載されている場合' do
        it 'バリデーションが通る' do
          task = Task.new(name: 'task02', explanation: '成功テスト')
          expect(task).to be_valid
        end
      end
    end
  end

  describe '検索機能', type: :model do
    describe 'scopeメソッドのテスト' do

      before do
        @task1 = FactoryBot.create(:task)
        @task2 = FactoryBot.create(:second_task)
        @task3 = FactoryBot.create(:third_task)
        @task4 = FactoryBot.create(:fourth_task)
        @task5 = FactoryBot.create(:fifth_task)
      end

      context '検索欄に記載がある場合' do
        it 'タイトルのあいまい検索ができる' do
          expect(Task.name_search('test')).to include(@task5)
        end
      end
      context '検索欄に記載がない場合' do
        it 'タスク一覧が表示される' do
          expect(Task.name_search("")).to include(@task1, @task2, @task3, @task4, @task5)
        end
      end

      context '進捗欄に記載がある場合' do
        it '該当するタスクが表示される' do
          expect(Task.progress_search("未着手")).to include(@task2, @task4)
          expect(Task.progress_search("着手中")).to include(@task1)
          expect(Task.progress_search("完了")).to include(@task3, @task5)
        end
      end

      context 'タイトル欄と進捗欄に記載があり検索する場合' do
        it '両方に該当するタスクが表示される' do
          expect(Task.progress_search("完了").name_search("test")).to include(@task5)
        end
      end

    end
  end
end
