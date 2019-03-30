$(function() {
    const HOST = 'localhost' // change this to your preferred domain
    const PORT = 3000 // you can change this port if you wish
    let url = `ws://${HOST}:${PORT}/chat`

    let websocket = new WebSocket(url)

    let username = prompt('username')
    
    websocket.onmessage = function(event) {
        $('#messages').append($(`<li>`).text(`${username}: ${event.data}`))
    }

    $('form').submit(function(event) {
        event.preventDefault()
        websocket.send($('#m').val())
        $('#m').val('')
        return false
    })
    
})
