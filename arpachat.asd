(defsystem "arpachat"
  :version "0.1.0"
  :author "Momozor"
  :license "MIT"
  :depends-on ("cl-json"
               "hunchensocket")
  :components ((:module "src"
                :components
                ((:file "main"))))
  :description "A web chat application with Websocket in Common Lisp"
  :long-description
  #.(read-file-string
     (subpathname *load-pathname* "README.markdown"))
  :in-order-to ((test-op (test-op "arpachat/tests"))))

(defsystem "arpachat/tests"
  :author "Momozor"
  :license "MIT"
  :depends-on ("arpachat"
               "rove")
  :components ((:module "tests"
                :components
                ((:file "main"))))
  :description "Test system for arpachat"

  :perform (test-op (op c) (symbol-call :rove :run c)))
