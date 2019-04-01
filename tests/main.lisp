(defpackage arpachat/tests/main
  (:use :cl
        :arpachat
        :rove)
  (:import-from :arpachat
                :client-decoder))
(in-package :arpachat/tests/main)

;; NOTE: To run this test file, execute `(asdf:test-system :arpachat)' in your Lisp.

(deftest test-username-client-data-decoding
  (testing "should equal catFace8923"
    (ok (string= (arpachat:client-decoder "{\"username\":\"catFace8923\", \"message\":\"yeS!\"}" t)
                 "catFace8923"))))

(deftest test-message-client-data-decoding
  (testing "should equal Hello from the-----underworld!!@%^!!!!! blargh&!"
    (ok (string= (arpachat:client-decoder "{\"username\":\"heh\", \"message\":\"Hello from the-----underworld!!@%^!!!!! blargh&!\"}" nil)
                 "Hello from the-----underworld!!@%^!!!!! blargh&!"))))

