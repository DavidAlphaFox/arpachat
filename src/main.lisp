(defpackage arpachat
  (:use :cl)
  (:export :start))
(in-package :arpachat)

(defparameter *handler*
  (intern (string-upcase
           (or (asdf::getenv "CLACK_HANDLER")
               "hunchentoot"))
          :keyword))

(defvar *app*
  (lambda (env)
    (cond
      ((string= "/chat" (getf env :request-uri))
       (let ((ws (websocket-driver:make-server env)))

         (websocket-driver:on :open ws
                              (lambda ()
                                (print "OPENED")))
         (websocket-driver:on :message ws
                              (lambda (message)
                                (websocket-driver:send ws message)))
         (websocket-driver:on :close ws
                              (lambda ()
                                (print "CLOSED")))
         (lambda (responder)
           (declare (ignore responder))
           (websocket-driver:start-connection ws)))))))

(defun start ()
  (clack:clackup *app* :server *handler* :use-thread nil))
