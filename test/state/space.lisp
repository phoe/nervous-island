;;;; test/state/space.lisp

(in-package #:nervous-island.test)

(define-class space-test-instant (nt:instant) ())
(define-class space-test-unit (nt:unit) ())
(define-class space-test-other-unit (nt:unit) ())
(define-class space-test-foundation (nt:foundation) ())
(define-class space-test-token (nto:token) ())

(define-test space-instantiation
  (let ((axial (nc:axial 0 0))
        (tokens (list (make-instance 'space-test-token)))
        (unit (make-instance 'space-test-unit))
        (unit-rotation 3)
        (foundation (make-instance 'space-test-foundation)))
    (flet ((make (&rest args) (apply #'make-instance 'nsp:space args)))
      (fail (make))
      (fail (make :axial 42) 'type-error)
      (fail (make :axial axial :tokens 42) 'type-error)
      (fail (make :axial axial :unit 42 :unit-rotation unit-rotation)
          'type-error)
      (fail (make :axial axial :unit unit))
      (fail (make :axial axial :unit-rotation unit-rotation))
      (fail (make :axial axial :unit unit :unit-rotation :w) 'type-error)
      (fail (make :axial axial :unit foundation :unit-rotation unit-rotation)
          'type-error)
      (fail (make :axial axial :foundation unit) 'type-error)
      (true (make :axial axial :unit unit :unit-rotation unit-rotation))
      (true (make :axial axial :unit unit :unit-rotation (+ 6 unit-rotation)))
      (true (make :axial axial :unit unit :unit-rotation (- 6 unit-rotation)))
      (true (make :axial axial :unit unit :unit-rotation unit-rotation
                  :foundation foundation :tokens tokens))
      (true (make :axial axial :foundation foundation))
      (true (make :axial axial :tokens tokens)))))

(define-test space-reinitialize
  (let* ((axial (nc:axial 0 0))
         (tokens (list (make-instance 'space-test-token)))
         (overlay (make-instance 'space-test-instant))
         (unit (make-instance 'space-test-unit))
         (unit-rotation 0)
         (foundation (make-instance 'space-test-foundation))
         (space (make-instance 'nsp:space :axial axial
                                          :tokens tokens
                                          :overlay overlay
                                          :unit unit
                                          :unit-rotation (+ 6 unit-rotation)
                                          :foundation foundation)))
    (is eqv axial (nsp:axial space))
    (is eqv tokens (nsp:tokens space))
    (is eqv overlay (nsp:overlay space))
    (is eqv unit (nsp:unit space))
    (is eqv unit-rotation (nsp:unit-rotation space))
    (is eqv foundation (nsp:foundation space))
    (is eqv space (reinitialize-instance space
                                         :unit-rotation (- 6 unit-rotation)))
    (is eqv axial (nsp:axial space))
    (is eqv tokens (nsp:tokens space))
    (is eqv overlay (nsp:overlay space))
    (is eqv unit (nsp:unit space))
    (is eqv unit-rotation (nsp:unit-rotation space))
    (is eqv foundation (nsp:foundation space))
    (let* ((new-axial (nc:axial 1 1))
           (args (list :axial new-axial :tokens '() :overlay nil
                       :unit nil :unit-rotation nil :foundation nil)))
      (is eqv space (apply #'reinitialize-instance space args))
      (is eqv new-axial (nsp:axial space))
      (false (nsp:tokens space))
      (false (nsp:overlay space))
      (false (nsp:unit space))
      (false (nsp:unit-rotation space))
      (false (nsp:foundation space)))))

(define-test space-spaces
  (let* ((things (list (nc:axial 0 0) (nsp:space '(0 1))))
         (axials (mapcar #'nc:ensure-axial '((0 0) (0 1))))
         (dict (apply #'nsp:spaces things)))
    (true (typep dict 'dict))
    (is = 2 (dict-count dict))
    (dolist (axial axials)
      (let ((thing (dict-find dict axial)))
        (true (typep thing 'nsp:space))
        (false (nsp:tokens thing))
        (false (nsp:unit thing))
        (false (nsp:unit-rotation thing))
        (false (nsp:foundation thing)))))
  (let* ((axial (nc:axial 0 0))
         (space-1 (make-instance 'nsp:space :axial axial))
         (space-2 (make-instance 'nsp:space :axial axial))
         (space-3 (make-instance 'nsp:space :axial axial))
         (dict (nsp:spaces space-1 space-2 space-3 axial)))
    (is = 1 (dict-count dict))))

(define-test space-find-element
  (let* ((token (make-instance 'space-test-token))
         (instant (make-instance 'space-test-instant))
         (unit (make-instance 'space-test-unit))
         (foundation (make-instance 'space-test-foundation)))
    (flet ((make (q r &rest args)
             (apply #'make-instance 'nsp:space :axial (nc:axial q r) args)))
      (let* ((space-1 (make 0 0 :tokens (list token)))
             (space-2 (make 0 1 :overlay instant))
             (space-3 (make 0 2 :unit unit :unit-rotation 0))
             (space-4 (make 0 3 :foundation foundation))
             (dict (nsp:spaces space-1 space-2 space-3 space-4)))
        (is eqv space-1 (nsp:find-element dict token))
        (is eqv space-2 (nsp:find-element dict instant))
        (is eqv space-3 (nsp:find-element dict unit))
        (is eqv space-4 (nsp:find-element dict foundation))
        (let ((other-unit (make-instance 'space-test-other-unit)))
          (false (nsp:find-element dict other-unit))))
      (let* ((omega-space (make 0 0 :tokens (list token) :overlay instant
                                    :unit unit :unit-rotation 0
                                    :foundation foundation))
             (dict (nsp:spaces omega-space)))
        (is eqv omega-space (nsp:find-element dict token))
        (is eqv omega-space (nsp:find-element dict instant))
        (is eqv omega-space (nsp:find-element dict unit))
        (is eqv omega-space (nsp:find-element dict foundation))
        (let ((other-unit (make-instance 'space-test-other-unit)))
          (false (nsp:find-element dict other-unit)))))))

(define-test space-augment-spaces
  (flet ((make (q r &rest args)
           (apply #'make-instance 'nsp:space :axial (nc:axial q r) args)))
    (let* ((space-1 (make 0 0))
           (space-2 (make 0 1))
           (dict-1 (nsp:spaces space-1 space-2))
           (token (make-instance 'space-test-token))
           (space-1-alt (make 0 0 :tokens (list token)))
           (space-3 (make 0 2))
           (dict-2 (nsp:spaces space-3))
           (dict-3 (nsp:augment-spaces dict-1 space-1-alt space-2 dict-2)))
      (is = 3 (dict-count dict-3))
      (is eqv space-1-alt (dict-find dict-3 (nc:axial 0 0)))
      (is eqv space-2 (dict-find dict-3 (nc:axial 0 1)))
      (is eqv space-3 (dict-find dict-3 (nc:axial 0 2))))))
