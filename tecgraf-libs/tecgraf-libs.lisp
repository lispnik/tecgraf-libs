(defpackage #:tecgraf-libs
  (:use #:common-lisp))

(in-package #:tecgraf-libs)

;;; (ironclad:byte-array-to-hex-string (ironclad:digest-file 'ironclad:sha256 "/etc/hosts"))
(defvar *archives*
  #+(and linux x86-64)
  '("https://sourceforge.net/projects/iup/files/3.25/Linux%20Libraries/iup-3.25_Linux44_64_lib.tar.gz"
    "318cbed5c418a93f69aac5946fe6fb24af2e53086ef93993752b228d978da07f"
    "https://sourceforge.net/projects/canvasdraw/files/5.11.1/Linux%20Libraries/cd-5.11.1_Linux44_64_lib.tar.gz"
    "a6eceb2e407bc9f00130f4e3382f9e3551a226506a66d0db3ec143504c17d60c"
    "https://sourceforge.net/projects/imtoolkit/files/3.12/Linux%20Libraries/im-3.12_Linux44_64_lib.tar.gz"
    "cbe54b01694ec343d87d1a986a53ab62664bd7dd71f953f2bdcc6c2b400edabb")
  #+(and windows x86-64)
  '("https://sourceforge.net/projects/iup/files/3.25/Windows%20Libraries/Dynamic/iup-3.25_Win64_dllw6_lib.zip"
    "4e281b40a327544307707ffb29156584112e37019ffad08179f1851343ce8ff2"
    "https://sourceforge.net/projects/canvasdraw/files/5.11.1/Windows%20Libraries/Dynamic/cd-5.11.1_Win64_dllw6_lib.zip"
    "7931850b14c7abfc700929c079a2255a303dd00271928dda658e4621dd9d7c33"
    "https://sourceforge.net/projects/imtoolkit/files/3.12/Windows%20Libraries/Dynamic/im-3.12_Win64_dllw6_lib.zip"
    "4b05e7f135d870f6997a920cd8fdb1cecae24d47495f4da4203c2dc01ce19d3a"))

(defconstant +buffer-size+ (* 1024 1024))

(defun download ()
  "Returns a list of pathnames to downloaded archives."
  (let ((result '()))
    ;; FIXME make work with digests
    (dolist (archive *archives* result)
      (format t "~&~A~%" archive)
      (finish-output)
      (let* ((archive-pathname (path:basename (puri:uri-path (puri:parse-uri archive))))
	     (output-pathname (asdf:system-relative-pathname :tecgraf-libs archive-pathname)))
	(with-open-file
	    (output-stream output-pathname :direction :output :if-exists :supersede :element-type '(unsigned-byte 8))
	  (multiple-value-bind
		(input-stream status-code)
	      (drakma:http-request archive :verify :required :want-stream t)
	    (if (= status-code 200)
		(loop with buffer = (make-array +buffer-size+ :element-type '(unsigned-byte 8))
		      for read-count = (read-sequence buffer input-stream)
		      do (write-sequence buffer output-stream :end read-count)
		      while (= read-count +buffer-size+)
		      finally (push output-pathname result))
		(error "Error downloading archive ~A" archive))))))))

;;; unpack them
;;; patchelf for ORIGIN
;;; copy to asdf target location

