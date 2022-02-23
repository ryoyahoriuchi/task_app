require 'rails_helper'
RSpec.describe 'タスク管理機能', type: :system do
  
  before do
    FactoryBot.create(:task)
    FactoryBot.create(:second_task)
  end

  describe '新規作成機能' do
    context 'タスクを新規作成した場合' do
      it '作成したタスクが表示される' do

        visit new_task_path
        fill_in 'Name', with: 'test001'
        fill_in 'Explanation', with: 'explanation001'
        click_button 'Create Task'
        visit tasks_path
        expect(page).to have_content 'test001'
        expect(page).to have_content 'explanation001'

      end
    end
  end
  describe '一覧表示機能' do
    context '一覧画面に遷移した場合' do
      it '作成済みのタスク一覧が表示される' do

        visit tasks_path
        expect(page).to have_content 'test_title'
        expect(page).to have_content 'test_explanation'
        expect(page).to have_content 'Factoryで作ったデフォルトの名前'
        expect(page).to have_content 'Factoryで作ったデフォルトの説明'

      end
    end
  end
  describe '詳細表示機能' do
     context '任意のタスク詳細画面に遷移した場合' do
       it '該当タスクの内容が表示される' do

        visit tasks_path
        all('table tbody tr')[0].click_link '詳細'
        expect(page).to have_content 'test_title'
        expect(page).to have_content 'test_explanation'
        click_link '戻る'
        all('table tbody tr')[1].click_link '詳細'
        expect(page).to have_content "Factoryで作ったデフォルトの名前"
        expect(page).to have_content 'Factoryで作ったデフォルトの説明'

       end
     end
  end
end