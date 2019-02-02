#lang racket/base
(require tests/eli-tester
         rackunit
         data/ring-buffer)
(require/expose data/ring-buffer
                (wrap-at wrap+))

(test
 (wrap-at 5 1) => 1
 (wrap-at 5 5) => 0
 (wrap-at 5 0) => 0
 (wrap-at 5 10) => 0
 (wrap-at 5 11) => 1
 (wrap+ 5 1 0) => 1
 (wrap+ 5 1 3) => 4
 (wrap+ 5 1 5) => 1
 (wrap+ 5 1 6) => 2
 (wrap+ 5 1 10) => 1
 (wrap+ 5 1 8) => 4)

(define (init k . as)
  (define fs (empty-ring-buffer k))
  (for ([a (in-list as)])
    (ring-buffer-push! fs a))
  fs)
(define (->list fs)
  (for/list ([i fs]) i))
(test
 (->list (init 5)) => (list)
 (->list (init 5 1)) => (list 1)
 (->list (init 5 1 2)) => (list 1 2)
 (->list (init 5 1 2 3)) => (list 1 2 3)
 (->list (init 5 1 2 3 4)) => (list 1 2 3 4)
 (->list (init 5 1 2 3 4 5)) => (list 1 2 3 4 5)
 (->list (init 5 1 2 3 4 5 6)) => (list 2 3 4 5 6)
 (->list (init 2 1 2 3 4 5)) => (list 4 5)
 (->list (init 0 1 2 3)) => (list)
 (->list (init 6 1 2 3)) => (list 1 2 3)
 (ring-buffer-ref (init 3 1 2 3 4) 1) => 3
 (let ([rb (init 3 1 2 3 4 5 6 7)])
   (ring-buffer-set! rb 2 8)
   (->list rb)) => (list 5 6 8)
 (let ([rb (init 3 1 2 3 4 5 6 7)])
   (vector (ring-buffer-pop! rb)
           (->list rb)))
 => (vector 7 (list 5 6))
 (let ([rb (init 3 1 2 3 4 5 6 7)])
   (vector (ring-buffer-pop! rb)
           (begin (ring-buffer-push! rb 8)
                  (->list rb))))
 => (vector 7 (list 5 6 8))
 (let ([rb (init 3 1 2 3 4 5 6 7)])
   (vector (ring-buffer-pop! rb)
           (begin (ring-buffer-push! rb 8)
                  (ring-buffer-push! rb 9)
                  (ring-buffer-push! rb 10)
                  (->list rb))))
 => (vector 7 (list 8 9 10))
 (let ([rb (init 3 1 2 3)])
   (vector (->list rb)
           (ring-buffer-pop! rb)
           (->list rb)
           (ring-buffer-push! rb 4)
           (->list rb)))
 => (vector (list 1 2 3)
            3
            (list 1 2)
            (void)
            (list 1 2 4)))

(test
 (init 5 #f) =error> "contract"
 (ring-buffer-set! (init 5 1 2 3) 1 #f) =error> "contract")
