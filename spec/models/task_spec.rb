require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'validation' do

  it 'is valid with all attributes' do 
    task = build(:task)
    expect(task).to be_valid
    expect(task.errors).to be_empty
  end

  it 'is invalid without title' do
    task_without_title = build(:task, title: "")
    expect(task_without_title).to be_invalid
    expect(task_without_title.errors[:title]).to eq ["can't be blank"]
  end

  it 'is invalid with a duplicate title' do
    task = create(:task)
    task_with_duplicate_title = build(:task, title: task.title)
    expect(task_with_duplicate_title).to be_invalid
    expect(task_with_duplicate_title.errors[:title]).to eq ["has already been taken"]
  end

  it 'is invalid without status' do
    task_without_status = build(:task, status: nil) 
    expect(task_without_status).to be_invalid
    expect(task_without_status.errors[:status]).to eq ["can't be blank"]
  end

  it 'is valid with another title' do
    task = create(:task)
    task_with_another_title = build(:task, title: "another_title")
    expect(task_with_another_title).to be_valid
    expect(task_with_another_title.errors[:title]).to be_empty
  end

  it 'is valid without content' do
    task_without_content = build(:task, content: "")
    expect(task_without_content).to be_valid
    expect(task_without_content.errors[:content]).to be_empty
  end

  it 'is valid without deadline' do
    task_without_deadline = build(:task, deadline: "")
    expect(task_without_deadline).to be_valid
    expect(task_without_deadline.errors[:deadline]).to be_empty
  end

  end
end
