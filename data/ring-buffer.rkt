#lang racket/base
(require racket/match
         racket/contract)

(define (wrap-at len i)
  (cond
    [(< i 0)
     (wrap-at len (+ len i))]
    [(<= len i)
     (wrap-at len (- i len))]
    [else
     i]))
(define (wrap+ len x y)
  (wrap-at len (+ x y)))

(define-struct ring-buffer (len [fst #:mutable] [cnt #:mutable] [nxt #:mutable] vals)
  #:property prop:sequence
  (lambda (rb)
    (match-define (ring-buffer len fst cnt nxt vals) rb)
    (make-do-sequence
     (λ ()
       (values
        (λ (p) (ring-buffer-ref rb p))
        (λ (p) (add1 p))
        0
        (λ (p) (< p cnt))
        (λ (v) v)
        (λ (p v) (and (< p cnt) v)))))))

(define (empty-ring-buffer len)
  (make-ring-buffer len #f 0 0 (make-vector len #f)))
(define (ring-buffer-push! rb m)
  (match-define (ring-buffer len fst cnt nxt vals) rb)
  (unless (zero? len)
    (if fst
      (when (= fst nxt)
        (set-ring-buffer-fst! rb (wrap+ len fst 1)))
      (set-ring-buffer-fst! rb 0))
    (vector-set! vals nxt m)
    (set-ring-buffer-nxt! rb (wrap+ len nxt 1))
    (set-ring-buffer-cnt! rb (min len (add1 cnt)))))
(define (ring-buffer-pop! rb)
  (match-define (ring-buffer len fst cnt nxt vals) rb)
  (when (zero? len) (error 'ring-buffer-pop! "No elements"))
  (define new-nxt (wrap+ len nxt -1))
  (set-ring-buffer-nxt! rb new-nxt)
  (set-ring-buffer-cnt! rb (sub1 cnt))
  (vector-ref vals new-nxt))

(define (ring-buffer-ref rb i)
  (match-define (ring-buffer len fst cnt nxt vals) rb)
  (unless (< i cnt) (error 'ring-buffer-ref "No element ~e" i))
  (vector-ref vals (wrap+ len (if fst fst 0) i)))
(define (ring-buffer-set! rb i v)
  (match-define (ring-buffer len fst cnt nxt vals) rb)
  (unless (< i cnt) (error 'ring-buffer-set! "No element ~e" i))
  (vector-set! vals (wrap+ len (if fst fst 0) i) v))

(provide
 (contract-out
  [empty-ring-buffer
   (-> exact-nonnegative-integer? ring-buffer?)]
  [ring-buffer?
   (-> any/c boolean?)]
  [rename ring-buffer-len ring-buffer-length
          (-> ring-buffer? exact-nonnegative-integer?)]
  [ring-buffer-ref
   (-> ring-buffer? exact-nonnegative-integer? (or/c any/c false/c))]
  [ring-buffer-set!
   (-> ring-buffer? exact-nonnegative-integer? (and/c any/c (not/c false/c)) void?)]
  [ring-buffer-push!
   (-> ring-buffer? (and/c any/c (not/c false/c)) void?)]
  [ring-buffer-pop!
   (-> ring-buffer? (and/c any/c (not/c false/c)))]))
