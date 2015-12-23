
Thread-safe queues and mailboxes.
Provides uniform queue/mailbox interface. On sbcl uses sb-concurrency and lparallel on others

## Example

``` lisp
(setf q (make-mailbox))
(mailbox-send-message q 1)
(mailbox-send-message q 2)
(mailbox-send-message q 3)
(mailbox-receive-message q)
1
(mailbox-receive-message q)
2
(mailbox-receive-message q)
3
(mailbox-receive-message-no-hang q)
NIL
NIL
(mailbox-receive-message q :timeout 5)
;; hopefuly after 5 seconds
NIL
NIL
(mailbox-receive-message q)
Thread blocked
```

## Authors

* 3b (https://github.com/3b)
* Ilya Khaprov (ilya.khaprov@publitechs.com)

## Copyright

Copyright (c) 2010-2013 3b <https://github.com/3b>

Copyright (c) 2013-2015 Ilya Khaprov <ilya.khaprov@publitechs.com>

## License

MIT


