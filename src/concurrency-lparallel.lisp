(in-package #:safe-queue)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Queues
;;;;   Thread safe queue
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(deftype queue ()
  'lparallel.queue:queue)

(defun make-queue (&key name initial-contents)
  "Returns a new QUEUE with NAME and contents of the INITIAL-CONTENTS
sequence enqueued."
  (declare (ignorable name))
  (lparallel.queue:make-queue :initial-contents initial-contents))

(defun enqueue (value queue)
  "Adds VALUE to the end of QUEUE. Returns VALUE."
  (lparallel.queue:push-queue value queue))

(defun dequeue (queue)
  "Retrieves the oldest value in QUEUE and returns it as the primary value,
and T as secondary value. If the queue is empty, returns NIL as both primary
and secondary value."
  (lparallel.queue:try-pop-queue queue))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Mailboxes
;;;;  Thread safe queue with ability to do blocking reads
;;;;  and get count of currently queueud items
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(deftype mailbox ()
  'lparallel.queue:queue)

(defun make-mailbox (&key name initial-contents)
  "Returns a new MAILBOX with messages in INITIAL-CONTENTS enqueued."
  (lparallel.queue:make-queue :initial-contents initial-contents))

(defun mailbox-empty-p (mailbox)
  "Returns true if MAILBOX is currently empty, NIL otherwise."
  (lparallel.queue:queue-empty-p mailbox))

(defun mailbox-send-message (mailbox message)
  "Adds a MESSAGE to MAILBOX. Message can be any object."
  (lparallel.queue:push-queue message mailbox))

(defun mailbox-receive-message (mailbox &key timeout)
  "Removes the oldest message from MAILBOX and returns it as the
primary value. If MAILBOX is empty waits until a message arrives."
  (if timeout
      (lparallel.queue:try-pop-queue mailbox :timeout timeout)
      (lparallel.queue:pop-queue mailbox)))

(defun mailbox-receive-message-no-hang (mailbox)
  "The non-blocking variant of RECEIVE-MESSAGE. Returns two values,
the message removed from MAILBOX, and a flag specifying whether a
message could be received."
  (lparallel.queue:try-pop-queue mailbox))

(defun mailbox-count (mailbox)
  "The non-blocking variant of RECEIVE-MESSAGE. Returns two values,
the message removed from MAILBOX, and a flag specifying whether a
message could be received."
  (lparallel.queue:queue-count mailbox))

(defun mailbox-list-messages (mailbox)
  "Returns a fresh list containing all the messages in the
mailbox. Does not remove messages from the mailbox."
  (declare (ignore mailbox))
  (error "not implemented"))

(defun mailbox-receive-pending-messages (mailbox &optional n)
  "Removes and returns all (or at most N) currently pending messages
from MAILBOX, or returns NIL if no messages are pending.

Note: Concurrent threads may be snarfing messages during the run of
this function, so even though X,Y appear right next to each other in
the result, does not necessarily mean that Y was the message sent
right after X."
  (loop with msg = nil
     with found = nil
     for i from 0
     while (or (not n) (< i n))
     do (setf (values msg found) (mailbox-receive-message-no-hang mailbox))
     while found
     collect msg))
