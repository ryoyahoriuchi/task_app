require 'rails_helper'

def visit_with_http_auth(path)
  username = ENV['USERNAME']
  password = ENV['PASSWORD']
  visit "http://#{username}:#{password}@#{Capybara.current_session.server.host}:#{Capybara.current_session.server.port}#{path}"
end

RSpec.describe 'ユーザー機能', type: :system do

  before do
    visit_with_http_auth root_path
  end

  describe 'ユーザー登録機能' do
    context 'ユーザーを新規登録した場合' do
      it 'ユーザーのマイページが表示される' do
        click_link 'Sign up'
        fill_in "user[name]", with: "test"
        fill_in "user[email]", with: "test@mail.com"
        fill_in "user[password]", with: "password"
        fill_in "user[password_confirmation]", with: "password"
        click_button "登録する"
        expect(page).to have_content "testのページ"
      end
    end

    context 'ユーザー登録していない場合' do
      it 'タスク一覧へアクセスできずログイン画面へ遷移する' do
        visit tasks_path
        expect(current_path).to eq new_session_path
      end
    end
  end

  describe 'セッション機能' do
    context 'ユーザー登録してある場合' do
      let!(:second_user) { FactoryBot.create(:second_user) }
      let!(:third_user) { FactoryBot.create(:third_user) }

      before do
        fill_in 'session[email]', with: 'test@mail.com'
        fill_in 'session[password]', with: 'password'
        click_button 'Log in'
      end

      it "ログインができる" do
        expect(page).to have_content "testのページ"
      end
      it '自分の詳細画面にアクセスできる' do
        click_link 'Index'
        click_link 'Profile'
        expect(page).to have_content "testのページ"
      end
      it '他人の詳細画面にアクセス出来ず、タスク一覧に遷移する' do
        visit user_path(third_user.id)
        expect(current_path).to eq tasks_path
      end
      it 'ログアウトができる' do
        click_link 'Logout'
        expect(current_path).to eq new_session_path
        expect(page).to have_content "ログアウトしました"
      end
    end
  end

  describe '管理機能' do
    let!(:second_user) { FactoryBot.create(:second_user) }
    let!(:third_user) { FactoryBot.create(:third_user) }
    
    context '管理ユーザーの場合' do
      before do
        fill_in 'session[email]', with: 'master@mail.com'
        fill_in 'session[password]', with: 'password'
        click_button 'Log in'
      end

      it '管理画面へアクセスできる' do
        visit admin_users_path
        expect(current_path).to eq admin_users_path
      end
      it 'ユーザーの新規登録ができる' do
        visit admin_users_path
        click_link 'ユーザー作成'
        fill_in "user[name]", with: "test2"
        fill_in "user[email]", with: "test2@mail.com"
        fill_in "user[password]", with: "password"
        fill_in "user[password_confirmation]", with: "password"
        select '管理', from: 'Admin'
        click_button "登録する"
        expect(page).to have_content "ユーザーを作成しました"
        expect(page).to have_content "test2"
        expect(page).to have_content "test2@mail.com"
      end
      it 'ユーザーの詳細画面にアクセスできる' do
        visit admin_users_path
        id = all('table tbody tr')
        sleep 0.1
        id[0].click_link '詳細'
        sleep 0.1
        expect(page).to have_content "testのタスク一覧"
        visit user_path(second_user.id)
        expect(page).to have_content "testのページ"
      end
      it 'ユーザーを編集できる' do
        visit admin_users_path
        id = all('table tbody tr')
        sleep 0.1
        id[0].click_link '編集'
        fill_in "user[name]", with: "master2"
        fill_in "user[email]", with: "master2@mail.com"
        select '管理', from: 'Admin'
        click_button "更新する"
        sleep 0.1
        expect(page).to have_content "ユーザーを編集しました"
        expect(page).to have_content "master2"
        expect(page).to have_content "master2@mail.com"
      end
      it 'ユーザーを削除できる' do
        visit admin_users_path
        expect(page).to have_content "test"
        expect(page).to have_content "test@mail.com"
        id = all('table tbody tr')
        sleep 0.1
        id[0].click_button '削除'
        expect(page).to have_content "ユーザーを削除しました"
        expect(page).to_not have_content "test"
        expect(page).to_not have_content "test@mail.com"
      end
    end

    context '一般ユーザーの場合' do
      it '管理画面へアクセスできない' do
        fill_in 'session[email]', with: 'test@mail.com'
        fill_in 'session[password]', with: 'password'
        click_button 'Log in'
        visit admin_users_path
        expect(current_path).to_not eq admin_users_path
        expect(page).to have_content "管理者以外はアクセス出来ないアドレスです"
      end
    end
  end
end