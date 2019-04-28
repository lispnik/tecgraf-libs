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
  :depends-on (#:cl-fad
               #:cl+ssl
               #:drakma
               #:cffi
               #:puri
               #+windows #:zip
               #+linux #:uiop
               #:trivial-features
               #:ironclad)
  :perform (load-op (o c)
                    (uiop:symbol-call "TECGRAF-LIBS" "DOWNLOAD")
                    (pushnew :tecgraf-libs *features*)))
