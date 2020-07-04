;;;; src/tiles/army.lisp

(uiop:define-package #:nervous-island.army
  (:use #:cl)
  (:local-nicknames (#:a #:alexandria)
                    (#:p #:protest/base))
  (:export
   ;; Army - protocol
   #:army #:hq #:name #:tiles))

(in-package #:nervous-island.army)

(protest/base:define-protocol-class army ()
  ((%hq :reader hq :initarg :hq)
   (%name :reader name :initarg :name)
   (%tiles :reader tiles))
  (:default-initargs :hq (a:required-argument :hq)
                     :name (a:required-argument :name)
                     :tiles (a:required-argument :tiles)))

(defmethod print-object ((object army) stream)
  (print-unreadable-object (object stream :type nil :identity t)
    (format stream "~A ~A" (name object) 'army)))

(defmethod initialize-instance :after ((army army) &key tiles)
  (let ((result '()))
    (dolist (tile tiles)
      (check-type tile (or symbol (cons symbol (cons (integer 1) null))))
      (let ((class (a:ensure-car tile))
            (count (if (consp tile) (second tile) 1)))
        (dotimes (i count) (push (make-instance class :owner army) result))))
    (setf (slot-value army '%tiles) (nreverse result))))