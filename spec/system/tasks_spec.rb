require 'rails_helper'

RSpec.describe "Tasks", type: :system do
let(:user){ create(:user) }
let(:task){ create(:task, user: user) }
  describe 'ログイン前' do
    describe 'ページの遷移' do
      it 'タスクの新規作成ページへのアクセスが失敗する' do
        visit new_task_path
        expect(page).to have_content 'Login required'
        expect(current_path).to eq login_path
      end
      it 'タスクの編集ページへのアクセスが失敗する' do
        visit edit_task_path(user)
        expect(page).to have_content 'Login required'
        expect(current_path).to eq login_path
      end
      it 'タスクの詳細情報が表示される' do
        visit task_path(task)
        expect(page).to have_content task.title
        expect(current_path).to eq task_path(task)
      end
      it 'タスク一覧画面にアクセスし、すべてのユーザーのタスク情報が表示される' do
        task_list = create_list(:task, 3)
        visit tasks_path
        expect(page).to have_content task_list[0].title
        expect(page).to have_content task_list[1].title
        expect(page).to have_content task_list[2].title
        expect(current_path).to eq tasks_path
      end
    end
  end


  describe 'ログイン後' do
    before { login_as(user) }
    describe 'タスクの新規作成' do
      before { visit new_task_path }
      context 'フォームの入力値が正常' do
        it 'タスクの新規作成が成功する' do
          fill_in 'Title', with: 'sample_title'
          fill_in 'Content', with: 'sample_content'
          select 'todo', from: 'task[status]'
          fill_in 'Deadline', with: DateTime.new(2020, 6, 1, 10, 30)
          click_button 'Create Task'
          expect(page).to have_content 'Task was successfully created.'
          expect(page).to have_content 'Title: sample_title'
          expect(page).to have_content 'Content: sample_content'
          expect(page).to have_content 'Status: todo'
          expect(page).to have_content 'Deadline: 2020/6/1 10:30'
          expect(current_path).to eq '/tasks/1'
        end
      end 

      context 'タイトルが未入力' do
        it 'タスクの新規作成が失敗する' do
          fill_in 'Content', with: 'sample_content'
          select 'todo', from: 'task[status]'
          fill_in 'Deadline', with: 1.week.from_now
          click_button 'Create Task'
          expect(page).to have_content "Title can't be blank"
          expect(current_path).to eq tasks_path
        end
      end

      context '登録済みのタイトルを使用' do
        it 'タスクの新規作成が失敗する' do
          other_task = create(:task)
          fill_in 'Title', with: other_task.title
          fill_in 'Content', with: 'sample_content'
          select 'todo', from: 'task[status]'
          fill_in 'Deadline', with: 1.week.from_now
          click_button 'Create Task'
          expect(page).to have_content "Title has already been taken"
          expect(current_path).to eq tasks_path
        end
      end
    end

    describe 'タスクの編集' do
      before { visit edit_task_path(task) }
      context 'フォームの入力値が正常' do
        it 'タスクの編集が成功する' do
          fill_in 'Title', with: 'update_title'
          fill_in 'Content', with: 'update_content'
          select 'doing', from: 'task[status]'
          fill_in 'Deadline', with: '2020, 12, 19, 10, 30'
          click_button 'Update Task'
          expect(page).to have_content "Task was successfully updated."
          expect(current_path).to eq task_path(task)
        end
      end 

      context 'タイトルが未入力' do
        it 'タスクの編集が失敗する' do
          fill_in 'Title', with: ''
          fill_in 'Content', with: 'update_content'
          select 'doing', from: 'task[status]'
          fill_in 'Deadline', with: '2020, 12, 19, 10, 30'
          click_button 'Update Task'
          expect(page).to have_content "Title can't be blank"
          expect(current_path).to eq task_path(task)
        end
      end

      context '登録済みのタイトルを使用' do
        it 'タスクの編集が失敗する' do
          other_task = create(:task)
          fill_in 'Title', with: other_task.title
          fill_in 'Content', with: 'update_content'
          select 'doing', from: 'task[status]'
          fill_in 'Deadline', with: '2020, 12, 19, 10, 30'
          click_button 'Update Task'
          expect(page).to have_content "Title has already been taken"
          expect(current_path).to eq task_path(task)
        end
      end
    end

    describe 'タスクの削除' do
      let!(:task) { create(:task, user: user) }
      it 'タスクの削除が成功する' do
        visit tasks_path
        click_link 'Destroy'
        expect(page.accept_confirm).to eq "Are you sure?"
        expect(page).to have_content "Task was successfully destroyed."
        expect(current_path).to eq tasks_path
        expect(page).not_to have_content task.title
      end
    end
    
    describe '他ユーザーのタスクの編集' do
      it '他ユーザーのタスク編集に失敗する' do
        other_user = create(:user)
        other_task = create(:task, user: other_user)
        visit edit_task_path(other_task)
        expect(page).to have_content "Forbidden access."
        expect(current_path).to eq root_path
      end
    end
  end
end
