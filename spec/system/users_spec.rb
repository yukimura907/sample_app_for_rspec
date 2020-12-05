require 'rails_helper'

RSpec.describe "Users", type: :system do
  describe 'ログイン前' do
    describe 'ユーザー新規登録' do
      before { visit sign_up_path }

      context 'フォームの入力値が正常' do
        it 'ユーザーの新規作成が成功する' do 
          fill_in 'Email', with: 'test@example.com'
          fill_in 'Password', with: 'test2046'
          fill_in 'Password confirmation', with: 'test2046'
          click_button 'SignUp'
          expect(page).to have_content 'User was successfully created.'
          expect(current_path).to eq login_path
        end
      end

      context 'メールアドレスが未入力' do
        it 'ユーザーの新規作成が失敗する' do
          fill_in 'Password', with: 'test2046'
          fill_in 'Password confirmation', with: 'test2046'
          click_button 'SignUp'
          expect(page).to have_content "Email can't be blank"
          expect(current_path).to eq users_path
        end
      end

      context '登録済のメールアドレスを使用' do
        it 'ユーザーの新規作成が失敗する' do 
          user = create(:user, email: "test@example.com")
          fill_in 'Email', with: 'test@example.com'
          fill_in 'Password', with: 'test2046'
          fill_in 'Password confirmation', with: 'test2046'
          click_button 'SignUp'
          expect(page).to have_content "Email has already been taken"
          expect(current_path).to eq users_path
        end
      end
    end

    describe 'マイページ' do
      context 'ログインしていない状態' do
        it 'マイページへのアクセスが失敗する' do
          user = create(:user)
          visit user_path(user)
          expect(current_path).to eq login_path
          expect(page).to have_content "Login required"
        end
      end
    end
  end

  describe 'ログイン後' do
    let(:user){ create(:user) }
    before { login_as(user) }

    describe 'ユーザー編集' do
      before { visit edit_user_path(user) }

      context 'フォームの入力値が正常' do
        it 'ユーザーの編集が成功する' do 
          fill_in 'Email', with: 'another@example.com'
          fill_in 'Password', with: 'another2046'
          fill_in 'Password confirmation', with: 'another2046'
          click_button 'Update'
          expect(page).to have_content "User was successfully updated."
          expect(current_path).to eq user_path(user)
        end
          
      end
      context 'メールアドレスが未入力' do
        it 'ユーザーの編集が失敗する' do
          fill_in 'Email', with: ''
          fill_in 'Password', with: 'another2046'
          fill_in 'Password confirmation', with: 'another2046'
          click_button 'Update'
          expect(page).to have_content "Email can't be blank"
          expect(current_path).to eq user_path(user)
        end
      end
      context '登録済のメールアドレスを使用' do
        it 'ユーザーの編集が失敗する' do
          other_user = create(:user)
          fill_in 'Email', with: other_user.email
          fill_in 'Password', with: 'another2046'
          fill_in 'Password confirmation', with: 'another2046'
          click_button 'Update'
          expect(page).to have_content "Email has already been taken"
          expect(current_path).to eq user_path(user)
        end
      end
    end
    describe '他ユーザーの編集ページにアクセス' do
      it '編集ページへのアクセスが失敗する' do 
        other_user = create(:user)
        visit edit_user_path(other_user)
        expect(page).to have_content "Forbidden access."
        expect(current_path).to eq user_path(user)
      end
    end

    describe 'マイページ' do
      context 'タスクを作成' do
        it '新規作成したタスクが表示される' do 
          task = create(:task, user: user)
          visit user_path(user)
          expect(page).to have_content task.title
        end
      end
    end
  end
end
