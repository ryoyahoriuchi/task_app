require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'タスクモデル機能', type: :model do
    describe 'バリデーションのテスト' do
      context 'タスクのタイトルがからの場合' do
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
end
