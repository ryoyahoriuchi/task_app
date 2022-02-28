require 'rails_helper'

def visit_with_http_auth(path)
  username = ENV['USERNAME']
  password = ENV['PASSWORD']
  visit "http://#{username}:#{password}@#{Capybara.current_session.server.host}:#{Capybara.current_session.server.port}#{path}"
end

RSpec.describe 'タスク管理機能', type: :system do
  
  before do
    # Task.destroy_all
    @task1 = FactoryBot.create(:task)
    @task2 = FactoryBot.create(:second_task)
    visit_with_http_auth root_path
  end

  describe '新規作成機能' do
    context 'タスクを新規作成した場合' do
      it '作成したタスクが表示される' do
        visit new_task_path
        fill_in 'タスク', with: 'test001'
        fill_in '説明文', with: 'explanation001'
        select_date("2022,5,11", from: "締切")
        select_time("11", "12", from: "締切")
        select '完了', from: '進捗'
        click_button '登録する'
        visit tasks_path
        expect(page).to have_content 'test001'
        expect(page).to have_content 'explanation001'
        expect(page).to have_content '2022/05/11 11:12'
        expect(page).to have_content '完了'

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

    context 'タスクが作成日時の降順に並んでいる場合' do
      it '新しいタスクが一番上に表示される' do
        visit tasks_path
        id = all('table tbody tr')
        expect(id[0]).to have_content 'Factoryで作ったデフォルトの名前'
        expect(id[0]).to have_content 'Factoryで作ったデフォルトの説明'
        expect(id[1]).to have_content 'test_title'
        expect(id[1]).to have_content 'test_explanation'

      end
    end

    context '終了期限でソートするというリンクを押す場合' do
      it '終了期限の降順に並び変えられたタスク一覧が表示される' do
        visit tasks_path
        click_link '終了期限でソートする'
        id = all('table tbody tr')
        expect(id[0]).to have_content 'test_title'
        expect(id[1]).to have_content 'Factoryで作ったデフォルトの名前'
      end
    end

    context '優先順位でソートするというリンクを押す場合' do
      it '優先順位の降順に並び替えられたタスク一覧が表示される' do
        @task3 = FactoryBot.create(:third_task)
        @task4 = FactoryBot.create(:fourth_task)
        @task5 = FactoryBot.create(:fifth_task)
        visit tasks_path
        click_link '優先順位でソートする'
        sleep(1)
        id = all('table tbody tr')
        expect(id[0]).to have_content '掃除'
        expect(id[1]).to have_content 'Factoryで作ったデフォルトの名前'
        expect(id[2]).to have_content 'test'
        expect(id[3]).to have_content 'test_title'
        expect(id[4]).to have_content 'rspec'
      end
    end
  end

  describe '詳細表示機能' do
    context '任意のタスク詳細画面に遷移した場合' do
     it '該当タスクの内容が表示される' do
      visit tasks_path
      id = all('table tbody tr')
      id[1].click_link '詳細'
      expect(page).to have_content 'test_title'
      expect(page).to have_content 'test_explanation'
      click_link '戻る'
      id = all('table tbody tr')
      id[0].click_link '詳細'
      expect(page).to have_content "Factoryで作ったデフォルトの名前"
      expect(page).to have_content 'Factoryで作ったデフォルトの説明'
      end
    end
  end

  describe '検索機能' do
    context 'タイトルだけで検索した場合' do
      it '該当タスクのみ表示される' do
        visit tasks_path
        fill_in 'task[search]', with: 'test'
        click_button '検索'
        id = all('table tbody tr')
        id.each do |i|
          expect(i).to have_content 'test'
        end
      end
    end

    context 'ステータスだけで検索した場合' do
      it '該当ステータスのみ表示される' do
        FactoryBot.create(:third_task)
        FactoryBot.create(:fourth_task)
        visit tasks_path
        find("option[value='未着手']").select_option
        click_button '検索'
        id = all('table tbody tr')
        id.each do |i|
          expect(i).to have_content "未着手"
          expect(i).not_to have_content "着手中"
          expect(i).not_to have_content "完了"
        end
      end
    end

    context 'タイトルとステータスの両方で検索した場合' do
      it '該当タスクと該当ステータスに合致するタスクが表示される' do
        FactoryBot.create(:third_task)
        FactoryBot.create(:fourth_task)
        FactoryBot.create(:fifth_task)
        visit tasks_path
        fill_in 'task[search]', with: 'test'
        find("option[value='完了']").select_option
        click_button '検索'
        id = all('table tbody tr')
        id.each do |i|
          expect(i).to have_content "test"
          expect(i).to have_content "完了"
        end
      end
    end
  end
end