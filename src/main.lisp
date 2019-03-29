(defpackage arpachat
  (:use :cl)
  (:export :start-ws
           :start
           :stop))
(in-package :arpachat)

(defun ws-server (port)
  (make-instance 'hunchensocket:websocket-acceptor :port port))

;; FIXME this server return 404 on the document-root
;;(defun static-server (port)
;;  (make-instance 'hunchentoot:acceptor :port port
;;                 :document-root #P"/home/momozor/quicklisp/local-projects/arpachat"))

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


(defparameter *ws-state* nil)
(defun start-ws (port)
  (setf *ws-state* (ws-server port))
  (hunchentoot:start *ws-state*))

;;(defun start-static (port)
;;  (hunchentoot:start (static-server port)))

(defun start (port)
  (start-ws port))

(defun stop ()
  (hunchentoot:stop *ws-state*))
;;(start-static sp))
