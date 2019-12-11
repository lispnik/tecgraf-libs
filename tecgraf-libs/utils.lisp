(in-package #:tecgraf-libs)

(defconstant +buffer-size+ (* 1024 1024))

(defun pathname-from-url (url)
  "Given http://example.com/foo.zip, return #p\"foo.zip\"."
  (path:basename (quri:uri-path (quri:uri url))))

(defun download-to-pathname (url output-pathname)
  (with-open-file
      (output-stream output-pathname :direction :output :if-exists :supersede :element-type '(unsigned-byte 8))
    (multiple-value-bind
          (input-stream status-code)
        (dex:get url :want-stream t :max-redirects 10)
      (if (= status-code 200)
          (loop with buffer
                  = (make-array +buffer-size+ :element-type '(unsigned-byte 8))
                for read-count = (read-sequence buffer input-stream)
                do (write-sequence buffer output-stream :end read-count)
                while (= read-count +buffer-size+))
          (cerror "Error downloading archive ~A, status code ~A" url status-code)))))
