require 'rails_helper'

RSpec.describe Api::V1::TasksController, type: :request do
  let(:user) do
    {
      id: Faker::Lorem.characters(10),
      name: Faker::Name
    }
  end

  describe '#index' do
    let!(:task1) do
      create(:task, user_id: user[:id], datetime: 3.days.from_now)
    end

    let!(:task2) do
      create(:task, user_id: user[:id], datetime: 1.day.from_now)
    end

    let!(:task3) do
      create(:task, user_id: user[:id], datetime: 12.hours.from_now)
    end

    before do
      authenticate_user(user)
      get '/api/v1/tasks', headers: { HTTP_ACCEPT: 'application/json ' }
    end

    it { expect(response).to have_http_status(:ok) }

    it 'returns tasks list' do
      expect(response).to match_response_schema('tasks')
    end

    it 'returns tasks list in correct order' do
      json = JSON.parse(response.body)

      expect(json[0]['id']).to eq task3.id
      expect(json[1]['id']).to eq task2.id
      expect(json[2]['id']).to eq task1.id
    end
  end
end
