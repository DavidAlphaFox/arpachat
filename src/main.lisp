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

;; Use (arpachat:start) to start websocket and static file server
;;     Default Ports: websocket - 3000, static file - 2000
;;     (arpachat:stop) to stop both servers
;;
;;     (arpachat:start-ws port) to start only websocket server
;;     (arpachat:start-static port) to start only static file server
;;
;;     (arpachat:stop-*) self explainable

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

;; decode client data
;; returns username or message string
(defun client-decoder (message usernamep)
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
  (setf *ws-state* (ws-server port))
  (hunchentoot:start *ws-state*))

(defvar *static-state* nil)
(defun start-static (port)
  (setf *static-state* (static-server port))
  (hunchentoot:start *static-state*))

(defun stop-ws ()
  (hunchentoot:stop *ws-state*))

(defun stop-static ()
  (hunchentoot:stop *static-state*))

(defun start (&key (websocket-port 3000) (static-port 2000))
  (start-ws websocket-port)
  (start-static static-port))

(defun stop ()
  (hunchentoot:stop *ws-state*)
  (hunchentoot:stop *static-state*))

