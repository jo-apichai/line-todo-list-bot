require 'rails_helper'

RSpec.describe 'Webhooks', type: :request do
  let(:params) { JSON.parse(File.read('spec/fixtures/webhooks/message.json')) }
  let(:headers) { { 'CONTENT_TYPE' => 'application/json' } }
  let(:reply_token) { params['events'][0]['replyToken'] }

  before do
    allow_any_instance_of(Line::Bot::Client).to receive(:validate_signature).
      and_return(true)

    allow_any_instance_of(Line::Bot::Client).to receive(:reply_message).
      and_return(true)
  end

  context 'User send a valid text message' do
    let(:task) { Task.last }
    let(:message) do
      { type: 'text', text: 'New task has been created' }
    end

    before { params['events'][0]['message']['text'] = text }

    context 'with date/month/year pattern' do
      let(:date) { 3.days.from_now }
      let(:text) { "Watch a movie : #{date.strftime('%-d/%-m/%y')} : 15:15" }

      it 'create new task and send reply message' do
        expect_any_instance_of(Line::Bot::Client).to receive(:reply_message).
          with(reply_token, message)

        expect do
          post webhooks_path, params: params.to_json, headers: headers
        end.to change { Task.count }.by(1)

        expect(task.description).to eq 'Watch a movie'
        expect(task.datetime).to eq date.change hour: 15, min: 15
      end
    end

    context 'with today' do
      let(:text) { 'Create Line Bot : today : 20:00' }

      it 'create new task and send reply message' do
        expect_any_instance_of(Line::Bot::Client).to receive(:reply_message).
          with(reply_token, message)

        expect do
          post webhooks_path, params: params.to_json, headers: headers
        end.to change { Task.count }.by(1)

        expect(task.description).to eq 'Create Line Bot'
        expect(task.datetime).to eq Time.zone.now.change hour: 20, min: 00
      end
    end

    context 'with tomorrow' do
      let(:text) { 'Read a book : tomorrow : 10:30' }

      it 'create new task and send reply message' do
        expect_any_instance_of(Line::Bot::Client).to receive(:reply_message).
          with(reply_token, message)

        expect do
          post webhooks_path, params: params.to_json, headers: headers
        end.to change { Task.count }.by(1)

        expect(task.description).to eq 'Read a book'
        expect(task.datetime).to eq 1.day.from_now.change hour: 10, min: 30
      end
    end

    context 'without specific time' do
      let(:date) { 5.days.from_now }
      let(:text) { "Go shopping : #{date.strftime('%-d/%-m/%y')}" }

      it 'create new task and send reply message' do
        expect_any_instance_of(Line::Bot::Client).to receive(:reply_message).
          with(reply_token, message)

        expect do
          post webhooks_path, params: params.to_json, headers: headers
        end.to change { Task.count }.by(1)

        expect(task.description).to eq 'Go shopping'
        expect(task.datetime).to eq 5.day.from_now.change hour: 12, min: 00
      end
    end
  end

  context 'User send edit text message' do
    let(:message) do
      { type: 'text', text: "To edit your todo list please visit #{root_url}" }
    end

    before { params['events'][0]['message']['text'] = 'edit' }

    it 'returns link to edit todo list page' do
      expect_any_instance_of(Line::Bot::Client).to receive(:reply_message).
        with(reply_token, message)

      post webhooks_path, params: params.to_json, headers: headers
    end
  end

  context 'User send an invalid text message' do
    before { params['events'][0]['message']['text'] = 'Hello, world' }

    it 'returns error message' do
      expect_any_instance_of(Line::Bot::Client).to receive(:reply_message).
        with(reply_token, { type: 'text', text: 'Invalid pattern' })

      post webhooks_path, params: params.to_json, headers: headers
    end
  end
end
