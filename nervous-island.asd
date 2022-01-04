;;;; nervous-island.asd

(asdf:defsystem #:nervous-island
  :description "ネウロ島六角ボードゲームエンジン"
  :author "Michał \"phoe\" Herda <phoe@disroot.org>"
  :license "AGPLv3"
  :version "0.0"
  :serial t
  :pathname "src"
  :components ((:module "common"
                :components ((:file "common")
                             (:file "macros")))
               (:module "tiles"
                :components ((:file "army")
                             (:file "skill")
                             (:file "attack")
                             (:file "effect")
                             (:file "tile")
                             (:file "instant")
                             (:file "token")))
               (:module "armies"
                :components ((:file "moloch")
                             (:file "outpost")
                             (:file "borgo")
                             (:file "hegemony")))
               (:module "state"
                :components ((:file "coord")
                             (:file "board")
                             (:file "space")
                             (:file "player")
                             (:file "damage")
                             (:file "phase")
                             (:file "step")
                             (:file "choice")
                             (:file "state")))
               (:module "gui"
                :components
                ((:module "shapes"
                  :components ((:file "package")
                               (:file "basics")
                               (:file "attacks")
                               (:file "net")
                               (:file "armor")
                               (:file "circle")
                               (:file "text")
                               (:file "mobility")
                               (:file "toughness")))
                 (:module "tilemaker"
                  :components ((:file "package")
                               (:file "conditions")
                               (:file "drawing-state")
                               (:file "draw-skill")
                               (:file "draw-skills")
                               (:file "draw-tile")))))
               (:file "user"))
  :depends-on (#:alexandria
               #:phoe-toolbox
               #:trivial-indent
               #:protest/base
               ;; GUI dependencies
               #:vecto
               #:imago
               #:vecto-imago)
  :in-order-to ((test-op (load-op :nervous-island.test)))
  :perform
  (test-op (o c)
           (symbol-call '#:parachute '#:test :nervous-island.test
                        :report (find-symbol "INTERACTIVE"
                                             "PARACHUTE"))))
