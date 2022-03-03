require 'rails_helper'

def visit_with_http_auth(path)
  username = ENV['USERNAME']
  password = ENV['PASSWORD']
  visit "http://#{username}:#{password}@#{Capybara.current_session.server.host}:#{Capybara.current_session.server.port}#{path}"
end

RSpec.describe 'タスク管理機能', type: :system do
  
  before do
    visit_with_http_auth root_path
  end

  let!(:second_user) { FactoryBot.create(:second_user) }
  let!(:task) { FactoryBot.create(:task, user: second_user) }
  let!(:second_task) { FactoryBot.create(:second_task, user: second_user) }

  describe '新規作成機能' do
    context 'タスクを新規作成した場合' do
      it '作成したタスクが表示される' do
        fill_in 'session[email]', with: 'test@mail.com'
        fill_in 'session[password]', with: 'password'
        click_button 'Log in'
        click_link 'Index'
        sleep 0.1
        click_button '新規作成'
        sleep 0.1
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
        fill_in 'session[email]', with: 'test@mail.com'
        fill_in 'session[password]', with: 'password'
        click_button 'Log in'
        click_link 'Index'
        expect(page).to have_content 'test_title'
        expect(page).to have_content 'test_explanation'
        expect(page).to have_content 'Factoryで作ったデフォルトの名前'
        expect(page).to have_content 'Factoryで作ったデフォルトの説明'
      end
    end

    context 'タスクが作成日時の降順に並んでいる場合' do
      it '新しいタスクが一番上に表示される' do
        fill_in 'session[email]', with: 'test@mail.com'
        fill_in 'session[password]', with: 'password'
        click_button 'Log in'
        click_link 'Index'
        id = all('table tbody tr')
        expect(id[0]).to have_content 'Factoryで作ったデフォルトの名前'
        expect(id[0]).to have_content 'Factoryで作ったデフォルトの説明'
        expect(id[1]).to have_content 'test_title'
        expect(id[1]).to have_content 'test_explanation'
      end
    end

    context '終了期限でソートするというリンクを押す場合' do
      it '終了期限の降順に並び変えられたタスク一覧が表示される' do
        fill_in 'session[email]', with: 'test@mail.com'
        fill_in 'session[password]', with: 'password'
        click_button 'Log in'
        click_link 'Index'
        click_link '終了期限でソートする'
        sleep 0.1
        id = all('table tbody tr')
        expect(id[0]).to have_content 'test_title'
        expect(id[1]).to have_content 'Factoryで作ったデフォルトの名前'
      end
    end

    context '優先順位でソートするというリンクを押す場合' do

      let!(:third_task) { FactoryBot.create(:third_task, user: second_user) }
      let!(:fourth_task) { FactoryBot.create(:fourth_task, user: second_user) }
      let!(:fifth_task) { FactoryBot.create(:fifth_task, user: second_user) }
      
      it '優先順位の降順に並び替えられたタスク一覧が表示される' do
        
        fill_in 'session[email]', with: 'test@mail.com'
        fill_in 'session[password]', with: 'password'
        click_button 'Log in'
        click_link 'Index'
        click_link '優先順位でソートする'
        sleep 0.1
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
      fill_in 'session[email]', with: 'test@mail.com'
      fill_in 'session[password]', with: 'password'
      click_button 'Log in'
      click_link 'Index'
      id = all('table tbody tr')
      id[1].click_link '詳細'
      sleep 0.1
      expect(page).to have_content 'test_title'
      expect(page).to have_content 'test_explanation'
      click_link '戻る'
      id = all('table tbody tr')
      id[0].click_link '詳細'
      sleep 0.1
      expect(page).to have_content "Factoryで作ったデフォルトの名前"
      expect(page).to have_content 'Factoryで作ったデフォルトの説明'
      end
    end
  end

  describe '検索機能' do
    context 'タイトルだけで検索した場合' do
      it '該当タスクのみ表示される' do
        fill_in 'session[email]', with: 'test@mail.com'
        fill_in 'session[password]', with: 'password'
        click_button 'Log in'
        click_link 'Index'
        fill_in 'task[search]', with: 'test'
        click_button '検索'
        id = all('table tbody tr')
        id.each do |i|
          expect(i).to have_content 'test'
        end
      end
    end

    context 'ステータスだけで検索した場合' do
      let!(:third_task) { FactoryBot.create(:third_task, user: second_user) }
      let!(:fourth_task) { FactoryBot.create(:fourth_task, user: second_user) }
      it '該当ステータスのみ表示される' do
        fill_in 'session[email]', with: 'test@mail.com'
        fill_in 'session[password]', with: 'password'
        click_button 'Log in'
        click_link 'Index'
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
      let!(:second_user) { FactoryBot.create(:second_user) }
      let!(:task) { FactoryBot.create(:task, user: second_user) }
      let!(:second_task) { FactoryBot.create(:second_task, user: second_user) }
      it '該当タスクと該当ステータスに合致するタスクが表示される' do
        fill_in 'session[email]', with: 'test@mail.com'
        fill_in 'session[password]', with: 'password'
        click_button 'Log in'
        click_link 'Index'
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