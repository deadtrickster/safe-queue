(in-package :cl-user)

(defpackage :safe-queue-system
  (:use :cl :asdf))

(in-package :safe-queue-system)

(defsystem :safe-queue
  :version "0.1"
  :description "Thread-safe queue and mailbox"
  :maintainer "Ilya Khaprov <ilya.khaprov@publitechs.com>"
  :author "3b <https://github.com/3b>"
  :licence "MIT"
  :depends-on (#+sbcl "sb-concurrency"
               #-sbcl "chanl")
  :serial t
  :components ((:file "src/package")
               #+sbcl(:file "src/sb-concurrency-patch")
               #+sbcl(:file "src/concurrency-sbcl")
               #-sbcl(:file "src/concurrency-chanl")))
