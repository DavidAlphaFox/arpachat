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

