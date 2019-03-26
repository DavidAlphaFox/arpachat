$(function() {
    let url = `ws://localhost:3000/chat`
    let output

    let websocket = new WebSocket(url)

    websocket.onmessage = function(event) {
        $('#messages').append($('<li>').text(event.data))
    }

    $('form').submit(function(event) {
        event.preventDefault()
        websocket.send($('#m').val())
        $('#m').val('')
        return false
    })
    
})
