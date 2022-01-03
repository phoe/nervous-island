(in-package #:nervous-island.tilemaker)

(draw-tile (make-instance 'nervous-island.armies.hegemony:net-master))
(draw-tile (make-instance 'nervous-island.armies.hegemony:universal-soldier))
(draw-tile (make-instance 'nt:warrior :skills (list (na:melee :q 6))))
(let ((skills (list (na:melee :q) (na:ranged :q) (na:gauss-cannon :q))))
  (draw-tile (make-instance 'nt:warrior :skills skills)))
(let ((skills (list (na:melee :s) (nsk:net :a) (nsk:net :d))))
  (draw-tile (make-instance 'nt:warrior :skills skills)))
