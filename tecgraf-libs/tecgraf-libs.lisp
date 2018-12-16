(defpackage #:tecgraf-libs
  (:use #:common-lisp))

(in-package #:tecgraf-libs)

(defvar *archives*
  #+linux
  '("https://sourceforge.net/projects/iup/files/3.25/Linux%20Libraries/iup-3.25_Linux44_64_lib.tar.gz"
    "https://sourceforge.net/projects/canvasdraw/files/5.11.1/Linux%20Libraries/cd-5.11.1_Linux44_64_lib.tar.gz"
    "https://sourceforge.net/projects/imtoolkit/files/3.12/Linux%20Libraries/im-3.12_Linux44_64_lib.tar.gz")
  #+windows
  '("https://sourceforge.net/projects/iup/files/3.25/Windows%20Libraries/Dynamic/iup-3.25_Win64_dllw6_lib.zip"
    "https://sourceforge.net/projects/canvasdraw/files/5.11.1/Windows%20Libraries/Dynamic/cd-5.11.1_Win64_dllw6_lib.zip"
    "https://sourceforge.net/projects/imtoolkit/files/3.12/Windows%20Libraries/Dynamic/im-3.12_Win64_dllw6_lib.zip"))

(defconstant +buffer-size+ (* 1024 1024))

(defun download ()
  (dolist (archive *archives*)
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
		    while (= read-count +buffer-size+))
	      (error "Error downloading archive ~A" archive)))))))


;;; download the files securely
;;; unpack them
;;; patchelf for ORIGIN
;;; copy to asdf target location

