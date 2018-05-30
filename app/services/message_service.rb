class MessageService
  def initialize(client:, event:)
    @client = client
    @event = event
  end

  def reply
    text = @event.message['text'].downcase

    text.eql?('edit') ? send_edit_link : create_task
  end

  private def create_task
    description, date, time = @event.message['text'].split(' : ')

    raise ArgumentError if description.blank? || date.blank?

    puts @event.to_s

    task = Task.new(
      user_id: @event['source']['userId'],
      description: description,
      datetime: parse_datetime(date, time)
    )

    send_reply_message 'New task has been created' if task.save
  rescue ArgumentError => e
    send_reply_message 'Invalid pattern'
  end

  private def send_edit_link
    url = Rails.application.routes.url_helpers.root_url
    send_reply_message "To edit your todo list please visit #{url}"
  end

  private def parse_datetime(date, time)
    time ||= '12:00'
    date_format = '%-d/%-m/%y'

    case date
    when 'today'
      date = Date.current.strftime(date_format)
    when 'tomorrow'
      date = Date.tomorrow.strftime(date_format)
    end

    return Time.zone.strptime("#{date} #{time}", '%d/%m/%y %H:%M')
  rescue ArgumentError => e
    send_reply_message 'Invalid pattern'
  end

  private def send_reply_message(text)
    message = {
      type: 'text',
      text: text
    }

    @client.reply_message(@event['replyToken'], message)
  end
end
