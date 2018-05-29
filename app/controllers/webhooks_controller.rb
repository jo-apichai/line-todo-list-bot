require 'line/bot'

class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :validate_signature

  def create
    events = client.parse_events_from(request.body.read)

    events.each do |event|
      next unless event.instance_of?(Line::Bot::Event::Message)
      next unless event.type.eql?(Line::Bot::Event::MessageType::Text)

      MessageService.new(client: client, event: event).reply
    end

    render plain: 'OK'
  end

  private def client
    @client ||= begin
      credentials = Rails.application.credentials

      Line::Bot::Client.new { |config|
        config.channel_secret = credentials.line[:channel_secret]
        config.channel_token = credentials.line[:channel_token]
      }
    end
  end

  private def validate_signature
    body = request.body.read
    signature = request.env['HTTP_X_LINE_SIGNATURE']

    unless client.validate_signature(body, signature)
      render plain: 'Bad Request', status: :bad_request
    end
  end
end
