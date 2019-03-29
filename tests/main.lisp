(defpackage arpachat/tests/main
  (:use :cl
        :arpachat
        :rove))
(in-package :arpachat/tests/main)

;; NOTE: To run this test file, execute `(asdf:test-system :arpachat)' in your Lisp.

(deftest test-target-1
  (testing "should (= 1 1) to be true"
    (ok (= 1 2)))) ;; fail test
