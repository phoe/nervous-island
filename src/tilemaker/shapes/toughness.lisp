(in-package #:nervous-island.tilemaker.shapes)

(defun toughness (rotation &optional (side *side*))
  (v:with-graphics-state
    (v:translate (* -0.55 side) 0)
    (v:rotate (* rotation pi 1/3))
    (v:set-rgba-fill 1 1 1 1)
    (v:translate 0 (* -0.01 side))
    (v:scale 1.6 1.2)
    (v:move-to (* 0.00 side) (* -0.05 side))
    (v:quadratic-to (* -0.05 side) (* -0.03 side)
                    (* -0.04 side) (* 0.06 side))
    (v:quadratic-to (* -0.025 side) (* 0.04 side)
                    (* 0.00 side) (* 0.06 side))
    (v:quadratic-to (* 0.025 side) (* 0.04 side)
                    (* 0.04 side) (* 0.06 side))
    (v:quadratic-to (* 0.05 side) (* -0.03 side)
                    (* 0.00 side) (* -0.05 side))
    (v:fill-path)))
