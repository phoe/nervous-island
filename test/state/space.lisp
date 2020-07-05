;;;; test/space.lisp

(in-package #:nervous-island.test)

(defclass space-test-tile (nt:tile) ())

(defclass space-test-foundation (nt:foundation) ())

(defclass space-test-token (nto:token) ())

(define-test space-instantiation
  (let ((axial (nc:make-axial 0 0))
        (tokens (list (make-instance 'space-test-token)))
        (tile (make-instance 'space-test-tile))
        (rotation :w)
        (foundation (make-instance 'space-test-foundation)))
    (fail (make-instance 'nsp:space))
    (fail (make-instance 'nsp:space :axial 42) 'type-error)
    (fail (make-instance 'nsp:space :axial axial :tokens 42) 'type-error)
    (fail (make-instance 'nsp:space :axial axial :tile 42) 'type-error)
    (fail (make-instance 'nsp:space :axial axial :tile tile))
    (fail (make-instance 'nsp:space :axial axial :rotation rotation))
    (fail (make-instance 'nsp:space :axial axial :tile tile :rotation 42)
        'type-error)
    (fail (make-instance 'nsp:space :axial axial :tile foundation
                                    :rotation rotation)
        'type-error)
    (fail (make-instance 'nsp:space :axial axial :foundation tile)
        'type-error)
    (true (make-instance 'nsp:space :axial axial :tile tile :rotation rotation))
    (true (make-instance 'nsp:space :axial axial :tile tile :rotation rotation
                                    :foundation foundation :tokens tokens))
    (true (make-instance 'nsp:space :axial axial :foundation foundation))
    (true (make-instance 'nsp:space :axial axial :tokens tokens))))

(define-test space-reinitialize
  (let* ((axial (nc:make-axial 0 0))
         (tokens (list (make-instance 'space-test-token)))
         (tile (make-instance 'space-test-tile))
         (rotation :w)
         (foundation (make-instance 'space-test-foundation))
         (space (make-instance 'nsp:space :axial axial :tokens tokens
                                          :tile tile :rotation rotation
                                          :foundation foundation)))
    (is eq tokens (nsp:tokens space))
    (is eq axial (nsp:axial space))
    (is eq tile (nsp:tile space))
    (is eq rotation (nsp:rotation space))
    (is eq foundation (nsp:foundation space))
    (is eq space (reinitialize-instance space))
    (is eq tokens (nsp:tokens space))
    (is eq axial (nsp:axial space))
    (is eq tile (nsp:tile space))
    (is eq rotation (nsp:rotation space))
    (is eq foundation (nsp:foundation space))))

(define-test space-make-spaces
  (let* ((things (list (nc:make-axial 0 0)
                       (make-instance 'nsp:space :axial (nc:make-axial 0 1))))
         (axials (mapcar #'nc:ensure-axial '((0 0) (0 1))))
         (spaces (apply #'nsp:make-spaces things)))
    (true (typep spaces 'hash-table))
    (is = 2 (hash-table-count spaces))
    (dolist (axial axials)
      (let ((thing (gethash axial spaces)))
        (true (typep thing 'nsp:space))
        (is eq '() (nsp:tokens thing))
        (is eq nil (nsp:tile thing))
        (is eq nil (nsp:rotation thing))
        (is eq nil (nsp:foundation thing)))))
  (let* ((axial (nc:make-axial 0 0))
         (space-1 (make-instance 'nsp:space :axial axial))
         (space-2 (make-instance 'nsp:space :axial axial)))
    (fail (nsp:make-spaces space-1 space-2) 'nb:duplicated-axial)))

(define-test space-edit-space
  (let* ((axial (nc:make-axial 0 0))
         (tokens-1 (list (make-instance 'space-test-token)))
         (tokens-2 (list (make-instance 'space-test-token)))
         (tile-1 (make-instance 'space-test-tile))
         (tile-2 (make-instance 'space-test-tile))
         (rotation-1 :w)
         (rotation-2 :s)
         (foundation-1 (make-instance 'space-test-foundation))
         (foundation-2 (make-instance 'space-test-foundation))
         (space-1 (make-instance 'nsp:space :axial axial :tokens tokens-1
                                            :tile tile-1 :rotation rotation-1
                                            :foundation foundation-1))
         (space-2 (nsp:edit-space space-1 :tokens tokens-2
                                          :tile tile-2 :rotation rotation-2
                                          :foundation foundation-2)))
    (isnt eq space-1 space-2)
    (is equalp (nsp:axial space-1) (nsp:axial space-2))
    (is eq tokens-1 (nsp:tokens space-1))
    (is eq tile-1 (nsp:tile space-1))
    (is eq rotation-1 (nsp:rotation space-1))
    (is eq foundation-1 (nsp:foundation space-1))
    (is eq tokens-2 (nsp:tokens space-2))
    (is eq tile-2 (nsp:tile space-2))
    (is eq rotation-2 (nsp:rotation space-2))
    (is eq foundation-2 (nsp:foundation space-2))))

(define-test space-edit-spaces
  (let* ((space-1 (make-instance 'nsp:space :axial (nc:make-axial 0 0)))
         (space-2 (make-instance 'nsp:space :axial (nc:make-axial 0 1)))
         (spaces (nsp:make-spaces space-1 space-2)))
    (is eq nil (nsp:tile space-1))
    (is eq nil (nsp:tile space-2))
    (let* ((tile (make-instance 'space-test-tile))
           (new-spaces (nsp:edit-spaces spaces space-2 :tile tile))
           (new-space (gethash (nc:make-axial 0 1) new-spaces)))
      (is = 2 (hash-table-count new-spaces))
      (is eq nil (nsp:tile space-1))
      (is eq nil (nsp:tile space-2))
      (is eq tile (nsp:tile new-space))))
  (let* ((space-1 (make-instance 'nsp:space :axial (nc:make-axial 0 0)))
         (space-2 (make-instance 'nsp:space :axial (nc:make-axial 0 1)))
         (spaces (nsp:make-spaces space-1 space-2)))
    (fail (nsp:edit-spaces spaces space-2 :axial (nc:make-axial 0 0))
        'nsp:cannot-edit-axial)))

(define-test space-find-tile)
