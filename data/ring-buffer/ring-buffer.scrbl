#lang scribble/doc
@(require scribble/manual
          scribble/eval
          (for-label racket/base
                     racket/contract
                     data/ring-buffer))

@(define the-eval 
   (let ([e (make-base-eval)])
     (e '(require data/ring-buffer))
     e))

@title{Ring Buffers}
@author{@(author+email "Jay McCarthy" "jay@racket-lang.org")}

@defmodule[data/ring-buffer]

This package defines an imperative, overwritting ring buffer that
holds a finite number of elements and may be used as a sequence.

@defproc[(ring-buffer? [v any/c])
         boolean?]{
 Determines if @racket[v] is a ring buffer.
}
                  
@defproc[(empty-ring-buffer [max exact-nonnegative-integer?])
         ring-buffer?]{
 Constructs an empty ring buffer that may hold @racket[max] elements.
}
                      
@defproc[(ring-buffer-length [rb ring-buffer?])
         exact-nonnegative-integer?]{
 Returns the length of @racket[rb].
}
              
@defproc[(ring-buffer-push! [rb ring-buffer?] [v (and/c any/c (not/c false/c))])
         void]{
 Pushes @racket[v] on to the end of @racket[rb], potentially pushing the first element of @racket[rb] off.
        
 @defexamples[#:eval the-eval
  (define rb (empty-ring-buffer 3))
  (ring-buffer-push! rb 1)
  (ring-buffer-push! rb 2)
  (ring-buffer-push! rb 3)
  (for/list ([v rb]) v)
  (ring-buffer-push! rb 4)
  (for/list ([v rb]) v)]
 }
                                    
@defproc[(ring-buffer-ref [rb ring-buffer?] [i exact-nonnegative-integer?])
         (or/c any/c false/c)]{
 Returns the value in the @racket[i]th position of @racket[rb].
         
 This interacts with @racket[ring-buffer-push!].
 @defexamples[#:eval the-eval
  (define rb (empty-ring-buffer 3))
  (ring-buffer-push! rb 1)
  (ring-buffer-push! rb 2)
  (ring-buffer-push! rb 3)
  (for/list ([v rb]) v)
  (ring-buffer-ref rb 1)
  (ring-buffer-push! rb 4)
  (ring-buffer-ref rb 1)]
 }
                              
@defproc[(ring-buffer-set! [rb ring-buffer?] [i exact-nonnegative-integer?] [v (and/c any/c (not/c false/c))])
         void]{
 Sets the value in the @racket[i]th position of @racket[rb] to @racket[v]
         
 This interacts with @racket[ring-buffer-push!].
}
              
