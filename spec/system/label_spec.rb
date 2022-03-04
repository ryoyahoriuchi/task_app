require 'rails_helper'

def visit_with_http_auth(path)
  username = ENV['USERNAME']
  password = ENV['PASSWORD']
  visit "http://#{username}:#{password}@#{Capybara.current_session.server.host}:#{Capybara.current_session.server.port}#{path}"
end

RSpec.describe 'ラベル機能', type: :system do
  let!(:second_label) { FactoryBot.create(:second_label) }
  let!(:third_label) { FactoryBot.create(:third_label) }
  let!(:fourth_label) { FactoryBot.create(:fourth_label) }
  let!(:third_user) { FactoryBot.create(:third_user) }

  before do
    visit_with_http_auth root_path
    fill_in 'session[email]', with: 'master@mail.com'
    fill_in 'session[password]', with: 'password'
    click_button 'Log in'
  end

  describe 'ラベル機能' do
    context 'タスクを新規作成する場合' do

      before do
        click_link "Index"
        id = all('table tbody tr')
        sleep 0.1
        expect(id).to_not have_content "赤"
        click_button "新規作成"
        fill_in "task[name]", with: "test1"
        fill_in "task[explanation]", with: "label create"
      end

      it 'ラベルも合わせて登録できる' do
        check '赤'
        click_button "登録する"
        expect(page).to have_content "タスクを作成しました"
        id = all('table tbody tr')
        sleep 0.1
        expect(id[0]).to have_content "赤"
        expect(id[0]).to_not have_content "青"
      end

      it 'ラベルを複数登録できる' do
        check "赤"
        check "青"
        check "黄"
        click_button "登録する"
        expect(page).to have_content "タスクを作成しました"
        id = all('table tbody tr')
        sleep 0.1
        expect(id[0]).to have_content "赤"
        expect(id[0]).to have_content "青"
        expect(id[0]).to have_content "黄"
      end
    end

    context 'タスクを編集する場合' do
      let!(:task) { FactoryBot.create(:task, user: third_user) }

      it 'ラベルも合わせて編集できる' do
        click_link "Index"
        id = all("table tbody tr")
        expect(id[0]).to_not have_content "赤"
        id[0].click_link "編集"
        check "赤"
        click_button "更新する"
        id = all("table tbody tr")
        expect(id[0]).to have_content "赤"
      end
    end
    context 'タスクの詳細画面を見る場合' do
      let!(:task) { FactoryBot.create(:task, user: third_user) }
      it 'ラベルも合わせて表示される' do
        click_link "Index"
        id = all("table tbody tr")
        id[0].click_link "編集"
        check "青"
        click_button "更新する"
        id = all("table tbody tr")
        id[0].click_link "詳細"
        expect(page).to have_content "青"
      end
    end
  end

  describe '検索機能' do
    let!(:task) { FactoryBot.create(:task, user: third_user) }
    before do
      click_link "Index"
      click_button "新規作成"
      fill_in "task[name]", with: "test1"
      fill_in "task[explanation]", with: "label red"
      check "赤"
      click_button "登録する"

      click_button "新規作成"
      fill_in "task[name]", with: "test2"
      fill_in "task[explanation]", with: "label blue"
      check "青"
      click_button "登録する"

      click_button "新規作成"
      fill_in "task[name]", with: "test3"
      fill_in "task[explanation]", with: "label yellow"
      check "黄"
      click_button "登録する"
    end
    context 'ラベルを選択して検索する場合' do
      it '該当するラベルのみ表示される' do
        select "青", from: "label_id"
        click_button 'ラベル検索'
        id = all("table tbody tr")
        id.each do |i|
          expect(i).to_not have_content "赤"
          expect(i).to have_content "青"
          expect(i).to_not have_content "黄"
        end
        select "赤", from: "label_id"
        click_button 'ラベル検索'
        id = all("table tbody tr")
        id.each do |i|
          expect(i).to have_content "赤"
          expect(i).to_not have_content "青"
          expect(i).to_not have_content "黄"
        end
        select "黄", from: "label_id"
        click_button 'ラベル検索'
        id = all("table tbody tr")
        id.each do |i|
          expect(i).to_not have_content "赤"
          expect(i).to_not have_content "青"
          expect(i).to have_content "黄"
        end
      end
    end
  end

end