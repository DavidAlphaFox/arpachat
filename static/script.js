//  This file is part of Arpachat.
//  Copyright (C) 2019  Momozor

//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.

//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.

//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <https://www.gnu.org/licenses/>.

$(function() {
    const HOST = 'localhost' // change this to your preferred domain
    const PORT = 3000 // you can change this port if you wish
    let username = prompt('username')

    let url = `ws://${HOST}:${PORT}/chat`

    let websocket = new WebSocket(url)

    websocket.onmessage = function(event) {
        $('#messages').append($(`<li>`).text(
            `${event.data}`
        ))
    }

    $('form').submit(function(event) {
        event.preventDefault()
        websocket.send(JSON.stringify({
            username: username,
            message: $('#m').val()
        }))

        
        $('#m').val('')
        return false
    })
    
})
