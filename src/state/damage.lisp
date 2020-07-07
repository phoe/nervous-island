;;;; src/state/damage.lisp

(uiop:define-package #:nervous-island.damage
  (:use #:cl)
  (:shadow #:number #:space)
  (:local-nicknames (#:a #:alexandria)
                    (#:p #:protest/base)
                    (#:Φ #:phoe-toolbox)
                    (#:na #:nervous-island.attack)
                    (#:ncom #:nervous-island.common)
                    (#:np #:nervous-island.player)
                    (#:ns #:nervous-island.step)
                    (#:nsk #:nervous-island.skill)
                    (#:nsp #:nervous-island.space)
                    (#:nt #:nervous-island.tile)
                    (#:nto #:nervous-island.token))
  (:export #:damage #:attack-damage #:non-attack-damage))

(in-package #:nervous-island.damage)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Damage - protocol

(ncom:define-typechecked-object damage ()
  ((target :type nt:tile)
   (value :type (or (integer 1) (eql t))))
  :protocolp t)

(ncom:define-typechecked-object attack-damage (damage)
  ((source :type (or nt:warrior nt:hq))
   (attack :type na:attack)
   (direction :type ncom:direction)))

(ncom:define-typechecked-object non-attack-damage (damage)
  ((source :type (or nt:instant nt:foundation nto:token))))
