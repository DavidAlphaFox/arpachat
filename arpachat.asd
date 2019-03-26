(defsystem "arpachat"
  :version "0.1.0"
  :author ""
  :license ""
  :depends-on ("cl-json"
               "hunchensocket")
  :components ((:module "src"
                :components
                ((:file "main"))))
  :description ""
  :long-description
  #.(read-file-string
     (subpathname *load-pathname* "README.markdown"))
  :in-order-to ((test-op (test-op "arpachat/tests"))))

(defsystem "arpachat/tests"
  :author ""
  :license ""
  :depends-on ("arpachat"
               "rove")
  :components ((:module "tests"
                :components
                ((:file "main"))))
  :description "Test system for arpachat"

  :perform (test-op (op c) (symbol-call :rove :run c)))
