(in-package #:nervous-island.tilemaker.shapes)

(defun circle-shadow (&optional (side *side*))
  (flet ((fn (x) (vecto:linear-domain (sin (* (- x) pi)))))
    (v:set-gradient-fill
     0 0 0 0 0 1
     (* 0.15 side) 0 0 0 0 0
     :domain-function #'fn
     :coordinates-function 'vecto:polar-coordinates))
  (v:arc 0 0 (* 0.225 side) 0 (* 2 pi))
  (v:fill-path))

(defun circle-outer (&optional (side *side*))
  (v:set-rgba-fill 0.95 0.95 0.85 1)
  (v:set-rgba-stroke 0 0 0 1)
  (v:set-line-width (* 0.015 side))
  (v:arc 0 0 (* 0.15 side) 0 (* 2 pi))
  (v:fill-and-stroke))

(defun circle-inner (&optional (side *side*))
  (v:set-rgba-fill 0 0 0 1)
  (v:arc 0 0 (* 0.13 side) 0 (* 2 pi))
  (v:fill-path))

(defun circle-decoration-square (&optional (side *side*))
  (v:set-rgba-fill 0.95 0.95 0.85 1)
  (v:translate (* 0.12 side) 0)
  (let ((n (* 0.012 side)))
    (v:move-to (- n) (- n))
    (v:line-to (- n) n)
    (v:line-to n n)
    (v:line-to n (- n))
    (v:line-to (- n) (- n))
    (v:fill-path)))

(defun circle-main-line (&optional (side *side*))
  (v:with-graphics-state
    (v:set-rgba-fill 0.95 0.95 0.85 1)
    ;;(v:arc 0 0 (* 0.05 side) 0 (* 2 pi))
    (v:translate (* -0.17 side) 0)
    (let ((n (* 0.04 side)))
      (v:move-to (- (* 1.75 n)) (- n))
      (v:line-to (- (* 1.75 n)) n)
      (v:line-to n n)
      (v:line-to n (- n))
      (v:line-to (- (* 1.75 n)) (- n))
      (v:fill-path))))

(defun circle-helper-line (y &optional (side *side*))
  (let ((y-mult (* 0.08 side)))
    (v:with-graphics-state
      (v:skew 0 (* y 2 pi 1/10))
      (v:set-rgba-fill 0.95 0.95 0.85 1)
      ;;(v:arc 0 0 (* 0.05 side) 0 (* 2 pi))
      (v:translate (* -0.18 side) 0)
      (let ((n (* 0.012 side)))
        (v:move-to (- (* 7 n)) (+ (* y y-mult) (- n)))
        (v:line-to (- (* 7 n)) (+ (* y y-mult) n))
        (v:line-to n (+ (* y y-mult) n))
        (v:line-to n (+ (* y y-mult) (- n)))
        (v:line-to (- (* 7 n)) (+ (* y y-mult) (- n)))
        (v:fill-path)))))

(defun ability-circle (&optional (side *side*))
  (v:with-graphics-state
    (v:translate (* -0.55 side) 0)
    (flet ()
      (circle-shadow)
      (circle-outer)
      (circle-inner)
      (dotimes (i 8)
        (v:with-graphics-state
          (v:rotate (* i 1/8 2 pi))
          (circle-decoration-square)))
      (circle-main-line)
      (dolist (y (list 1 -1))
        (circle-helper-line y)))))