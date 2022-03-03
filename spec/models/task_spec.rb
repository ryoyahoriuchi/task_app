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
          user = FactoryBot.create(:second_user)
          task = Task.new(name: 'task02', explanation: '成功テスト', user_id: user.id)
          expect(task).to be_valid
          User.destroy_all
        end
      end 
    end
  end

  describe '検索機能', type: :model do
    describe 'scopeメソッドのテスト' do

      let!(:second_user) { FactoryBot.create(:second_user) }
      let!(:task) { FactoryBot.create(:task, user: second_user) }
      let!(:second_task) { FactoryBot.create(:second_task, user: second_user) }
      let!(:third_task) { FactoryBot.create(:third_task, user: second_user) }
      let!(:fourth_task) { FactoryBot.create(:fourth_task, user: second_user) }
      let!(:fifth_task) { FactoryBot.create(:fifth_task, user: second_user) }

      context '検索欄に記載がある場合' do
        it 'タイトルのあいまい検索ができる' do
          expect(Task.name_search('test')).to include(task, fifth_task)
          expect(Task.name_search('test')).to_not include(second_task, third_task, fourth_task)
        end
      end
      context '検索欄に記載がない場合' do
        it 'タスク一覧が表示される' do
          expect(Task.name_search("")).to include(task, second_task, third_task, fourth_task, fifth_task)
        end
      end

      context '進捗欄に記載がある場合' do
        it '該当するタスクが表示される' do
          expect(Task.progress_search("未着手")).to include(second_task, fourth_task)
          expect(Task.progress_search("着手中")).to include(task)
          expect(Task.progress_search("完了")).to include(third_task, fifth_task)
        end
      end

      context 'タイトル欄と進捗欄に記載があり検索する場合' do
        it '両方に該当するタスクが表示される' do
          expect(Task.progress_search("完了").name_search("test")).to include(fifth_task)
        end
      end

    end
  end
end
