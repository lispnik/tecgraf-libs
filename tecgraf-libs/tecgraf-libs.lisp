(defpackage #:tecgraf-libs
  (:use #:common-lisp))

(in-package #:tecgraf-libs)

;;; (ironclad:byte-array-to-hex-string (ironclad:digest-file 'ironclad:sha256 #p"/etc/hosts"))

(defvar *archives*
  #+(and linux x86-64)
  '(("https://sourceforge.net/projects/iup/files/3.25/Linux%20Libraries/iup-3.25_Linux44_64_lib.tar.gz"
     "318cbed5c418a93f69aac5946fe6fb24af2e53086ef93993752b228d978da07f")
    ("https://sourceforge.net/projects/canvasdraw/files/5.11.1/Linux%20Libraries/cd-5.11.1_Linux44_64_lib.tar.gz"
     "a6eceb2e407bc9f00130f4e3382f9e3551a226506a66d0db3ec143504c17d60c")
    ("https://sourceforge.net/projects/imtoolkit/files/3.12/Linux%20Libraries/im-3.12_Linux44_64_lib.tar.gz"
     "cbe54b01694ec343d87d1a986a53ab62664bd7dd71f953f2bdcc6c2b400edabb"))
  #+(and windows x86-64)
  '(("https://sourceforge.net/projects/iup/files/3.25/Windows%20Libraries/Dynamic/iup-3.25_Win64_dllw6_lib.zip"
     "4e281b40a327544307707ffb29156584112e37019ffad08179f1851343ce8ff2")
    ("https://sourceforge.net/projects/canvasdraw/files/5.11.1/Windows%20Libraries/Dynamic/cd-5.11.1_Win64_dllw6_lib.zip"
     "7931850b14c7abfc700929c079a2255a303dd00271928dda658e4621dd9d7c33")
    ("https://sourceforge.net/projects/imtoolkit/files/3.12/Windows%20Libraries/Dynamic/im-3.12_Win64_dllw6_lib.zip"
     "4b05e7f135d870f6997a920cd8fdb1cecae24d47495f4da4203c2dc01ce19d3a")))


(defun download-tecgraf-libs ()
  (loop for (archive-url hash) in *archives*
	for archive-pathname = (pathname-from-url archive-url)
	for output-pathname = (asdf:system-relative-pathname :tecgraf-libs archive-pathname)
	do (download-to-pathname archive-url output-pathname)
	collect (list output-pathname hash)))

(defun verify (downloads)
  (loop for (pathname expected-hash) in downloads
	for download-hash = (ironclad:byte-array-to-hex-string (ironclad:digest-file 'ironclad:sha256 pathname))
	for match = (string= download-hash expected-hash)
	do (unless match
	     (error "Checksum for ~A does not match (got ~A, expected ~A)" pathname download-hash expected-hash))
	collect pathname))

(defun download ()
  (let* ((downloaded (download-tecgraf-libs))
	 (verified (verify downloaded)))
    verified))

;;; unpack them
;;; patchelf for ORIGIN
;;; copy to asdf target location

