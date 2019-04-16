;;  This file is part of Arpachat.
;;  Copyright (C) 2019  Momozor

;;  This program is free software: you can redistribute it and/or modify
;;  it under the terms of the GNU General Public License as published by
;;  the Free Software Foundation, either version 3 of the License, or
;;  (at your option) any later version.

;;  This program is distributed in the hope that it will be useful,
;;  but WITHOUT ANY WARRANTY; without even the implied warranty of
;;  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;  GNU General Public License for more details.

;;  You should have received a copy of the GNU General Public License
;;  along with this program.  If not, see <https://www.gnu.org/licenses/>.

(defpackage arpachat
  (:use :cl)
  (:export :client-decoder
           :start-ws
           :start-static
           :stop-ws
           :stop-static
           :start
           :stop))
(in-package :arpachat)

;;; chat room
(defclass chat-room (hunchensocket:websocket-resource)
  ((name :initarg :name
         :initform (error "Name this room!")
         :reader name))
  (:default-initargs :client-class 'user))

(defclass user (hunchensocket:websocket-client)
  ((name :initarg :user-agent
         :initform (error "Name this user!")
         :reader name)))

(defvar *chat-rooms* (list (make-instance 'chat-room :name "/chat")))

(defun find-room (request)
  (find (hunchentoot:script-name request) *chat-rooms* :test #'string= :key #'name))

(pushnew 'find-room hunchensocket:*websocket-dispatch-table*)

(defun broadcast (room message &rest args)
  (loop for peer in (hunchensocket:clients room)
     do (hunchensocket:send-text-message peer (apply #'format nil message args))))

(defmethod hunchensocket:client-connected ((room chat-room) user)
  (broadcast room "A user has entered the chat room"))

(defmethod hunchensocket:client-disconnected ((room chat-room) user)
  (broadcast room "A user has left the room"))

(defun client-decoder (message usernamep)
  "decodes client data from json to string
   returns username or message in string"
  (let ((dj (cl-json:decode-json-from-string message)))
    (if usernamep
        (cdr (assoc :username dj))
        (cdr (assoc :message dj)))))

(defmethod hunchensocket:text-message-received ((room chat-room) user message)
  (broadcast room "~a: ~a" (client-decoder message t) (client-decoder message nil)))

;;; servers

(defun ws-server (port)
  (make-instance 'hunchensocket:websocket-acceptor :port port))

;; portable root dir (in local-projects)
(defparameter *application-root*
  (asdf:system-source-directory :arpachat))

(defparameter *static-directory*
  (merge-pathnames #P"static/" *application-root*))

(defun static-server (port)
  (make-instance 'hunchentoot:acceptor :port port
                 :document-root *static-directory*))

(defvar *ws-state* nil)
(defun start-ws (port)
  "start websocket server
   :p port fixnum"
  (setf *ws-state* (ws-server port))
  (hunchentoot:start *ws-state*))

(defvar *static-state* nil)
(defun start-static (port)
  "start static file server
   :p port fixnum"
  (setf *static-state* (static-server port))
  (hunchentoot:start *static-state*))

(defun stop-ws ()
  "stop websocket server"
  (hunchentoot:stop *ws-state*))

(defun stop-static ()
  "stop static file server"
  (hunchentoot:stop *static-state*))

(defun start (&key (websocket-port 3000) (static-port 2000))
  "start both websocket and static file servers
   :p websocket-port fixnum - default to 3000
   :p static-port fixnum - default to 2000"
  (start-ws websocket-port)
  (start-static static-port))

(defun stop ()
  "stop both websocket and static file servers"
  (hunchentoot:stop *ws-state*)
  (hunchentoot:stop *static-state*))

