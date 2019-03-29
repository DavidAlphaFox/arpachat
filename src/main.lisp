(defpackage arpachat
  (:use :cl)
  (:export :start-ws
           :start-static
           :stop-ws
           :stop-static
           :start
           :stop))
(in-package :arpachat)

;;; chat room
(defclass chat-room (hunchensocket:websocket-resource)
  ((name :initarg :name :initform (error "Name this room!") :reader name))
  (:default-initargs :client-class 'user))

(defclass user (hunchensocket:websocket-client)
  ((name :initarg :user-agent :reader name :initform (error "Name this user!"))))

(defvar *chat-rooms* (list (make-instance 'chat-room :name "/chat")))

(defun find-room (request)
  (find (hunchentoot:script-name request) *chat-rooms* :test #'string= :key #'name))

(pushnew 'find-room hunchensocket:*websocket-dispatch-table*)

(defun broadcast (room message &rest args)
  (loop for peer in (hunchensocket:clients room)
     do (hunchensocket:send-text-message peer (apply #'format nil message args))))

(defmethod hunchensocket:client-connected ((room chat-room) user)
  (broadcast room "~a has joined ~a" (name user) (name room)))

(defmethod hunchensocket:client-disconnected ((room chat-room) user)
  (broadcast room "~a has left ~a" (name user) (name room)))

(defmethod hunchensocket:text-message-received ((room chat-room) user message)
  (broadcast room "~a says ~a" (name user) message))

;;; servers

(defun ws-server (port)
  (make-instance 'hunchensocket:websocket-acceptor :port port))

;; FIXME make the root start dir portable (start in other people arpachat dir, not just
;; momozor's)
(defun static-server (port)
  (make-instance 'hunchentoot:acceptor :port port
                 :document-root #p"/home/momozor/quicklisp/local-projects/arpachat/index.html"))


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

