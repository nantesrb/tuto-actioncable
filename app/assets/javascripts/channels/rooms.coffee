App.rooms = App.cable.subscriptions.create {
    channel: "RoomsChannel",
    room_id: $('#messages').data('room-id')
  },

  connected: ->

  received: (data) ->
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
    return false
