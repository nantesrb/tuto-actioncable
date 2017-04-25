App.rooms = App.cable.subscriptions.create {
    channel: "RoomsChannel",
    room_id: $('#messages').data('room-id')
  },

  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    $('#messages').append(data.message)

  send_message: (message, room_id) ->
    @perform 'send_message', message: message, room_id: room_id

  $('#new_message').submit (e) ->
    $this = $(this)
    textarea = $this.find('#message_content')
    if $.trim(textarea.val()).length > 1
      App.rooms.send_message textarea.val(), $('#messages').data('room-id')
      textarea.val('')
    e.preventDefault()
    false
