# Arpachat
A chat web application using Websockets and Common Lisp

## Installation
* Make sure you have *Quicklisp* installed
* `git clone https://github.com/momozor/arpachat /path/to/quicklisp/local-projects/`
* Launch your Lisp interpreter and run `(ql:quickload :arpachat)

## Usage
* `(ql:quickload :arpachat)`
* `(arpachat:start)` to start a websocket server at port 3000 
and static file server at 2000 by default. To stop them, run `(arpachat:stop)` to stop both of the
servers.
* Launch a web browser and navigate to http://localhost:2000 to use the chat application.
* Enjoy! :)

If you find this software is helpful in any way, please click the***star*** button.

## Authors
* Momozor

## License
This project is licensed under the MIT license. See LICENSE file for more details
