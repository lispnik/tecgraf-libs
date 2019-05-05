(defsystem #:tecgraf-libs
  :description "Tecgraf Shared Libraries"
  :author "Matthew Kennedy <burnsidemk@gmail.com>"
  :homepage "https://github.com/lispnik/tecgraf-libs"
  :license "MIT"
  :serial t
  :pathname "tecgraf-libs"
  :components ((:file "package")
               (:file "utils")
               (:file "tecgraf-libs"))
  :depends-on (#:trivial-features
               #:cl-fad
               #:cl+ssl
               #:drakma
               #:cffi
               #:puri
               #+(or (and sbcl os-windows) (and ccl windows)) #:zip
               #+linux #:uiop
               #:ironclad)
  :perform (load-op :after (o c)
                    (uiop:symbol-call "TECGRAF-LIBS" "DOWNLOAD")
                    (pushnew :tecgraf-libs *features*)))
