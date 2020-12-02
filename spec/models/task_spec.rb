require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'validation' do

  it 'is valid with all attributes' do 
    task = build(:task)
    expect(task).to be_valid
    expect(task.errors).to be_empty
  end

  it 'is invalid without title' do
    task = FactoryBot.create(:task)
    task.update(title: nil)
    expect(task.errors[:title]).to include("can't be blank")
  end

  it 'is invalid with a duplicate title' do
    task = FactoryBot.create(:task)
    expect(FactoryBot.build(:task)).to_not be_valid 
  end

  it 'is invalid without status' do
    task = FactoryBot.create(:task)
    task.update(status: nil)
    expect(task.errors[:status]).to include("can't be blank")
  end

  it 'is valid without content' do
    task = FactoryBot.create(:task)
    task.update(content: nil)
    expect(task).to be_valid
  end

  it 'is valid without deadline' do
    task = FactoryBot.create(:task)
    task.update(deadline: nil)
    expect(task).to be_valid
  end

  end
end
