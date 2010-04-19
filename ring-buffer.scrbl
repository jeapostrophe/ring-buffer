#lang scribble/doc
@(require (planet cce/scheme:4:1/planet)
          scribble/manual
          scribble/eval
          (for-label scheme/base
                     scheme/contract
                     "main.ss"))

@(define the-eval 
   (let ([e (make-base-eval)])
     (e '(require "main.ss"))
     e))

@title{Ring Buffers}
@author{@(author+email "Jay McCarthy" "jay@plt-scheme.org")}

@defmodule/this-package[]

This package defines an imperative, overwritting ring buffer that holds a finite number of elements
and may be used as a sequence.

@defproc[(ring-buffer? [v any/c])
         boolean?]{
 Determines if @scheme[v] is a ring buffer.
}
                  
@defproc[(empty-ring-buffer [max exact-nonnegative-integer?])
         ring-buffer?]{
 Constructs an empty ring buffer that may hold @scheme[max] elements.
}
                      
@defproc[(ring-buffer-length [rb ring-buffer?])
         exact-nonnegative-integer?]{
 Returns the length of @scheme[rb].
}
              
@defproc[(ring-buffer-push! [rb ring-buffer?] [v (and/c any/c (not/c false/c))])
         void]{
 Pushes @scheme[v] on to the end of @scheme[rb], potentially pushing the first element of @scheme[rb] off.
        
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
 Returns the value in the @scheme[i]th position of @scheme[rb].
         
 This interacts with @scheme[ring-buffer-push!].
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
 Sets the value in the @scheme[i]th position of @scheme[rb] to @scheme[v]
         
 This interacts with @scheme[ring-buffer-push!].
}
              