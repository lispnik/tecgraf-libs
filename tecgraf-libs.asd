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
  :depends-on (#:cl+ssl
	       #:drakma
	       #:cffi
	       #:puri
	       #:cl-fad
	       #:deflate
	       #:trivial-features
	       #:ironclad))
