require 'rails_helper'

RSpec.describe "Tasks", type: :system do

describe 'ログイン前' do
  describe 'ページの遷移' do
    it 'タスクの新規作成ページへのアクセスが失敗する'
    
    it 'タスクの編集ページへのアクセスが失敗する'
  end


  describe 'ログイン後' do
    describe 'タスクの新規作成' do
      context 'フォームの入力値が正常' do
        it 'タスクの新規作成が成功する'
      end 

      context 'タイトルが未入力' do
        it 'タスクの新規作成が失敗する'
      end

      context '登録済みのタイトルを使用' do
        it 'タスクの新規作成が失敗する'
      end
    end

    describe 'タスクの編集' do
      context 'フォームの入力値が正常' do
        it 'タスクの新規作成が成功する'
      end 

      context 'タイトルが未入力' do
        it 'タスクの新規作成が失敗する'
      end

      context '登録済みのタイトルを使用' do
        it 'タスクの新規作成が失敗する'
      end
    end

    describe 'タスクの削除' do
      it 'タスクの削除が成功する'
    end
    
    describe '他ユーザーのタスクの編集' do
      it '他ユーザーのタスク編集に失敗する'
    end
  end
end
end
