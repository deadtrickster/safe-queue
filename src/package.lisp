(in-package :cl-user)

(defpackage :safe-queue
  (:use :cl)
  (:export #:make-queue
           #:enqueue
           #:dequeue
           #:make-mailbox
           #:mailbox-empty-p
           #:mailbox-send-message
           #:mailbox-receive-message
           #:mailbox-receive-message-no-hang
           #:mailbox-count
           #:mailbox-list-messages
           #:mailbox-receive-pending-messages))
