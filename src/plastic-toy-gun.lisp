(in-package :cl-user)
(defpackage plastic-toy-gun
  (:use :cl)
  (:use :usocket)
  (:use :bordeaux-threads)
  (:export :start
           :dispose
           :*debug-log*
           :*cartridge*
           :make-server))

(in-package :plastic-toy-gun)

(defparameter *debug-log* t)
(defparameter *cartridge* '())

(defun make-server (&key (port 8080) (address "localhost"))
  (usocket:socket-listen address port :reuseaddress t :element-type '(unsigned-byte 8)))

(defun accept (server)
  (usocket:socket-accept server))

(defun dispose (server)
  (format *debug-log* "dispose server~%")
  (usocket:socket-close server))

(defun handler (client)
  (handler-case
   (with-open-stream (stream (usocket:socket-stream client))
                     (funcall *cartridge* stream))
   (error (c) (format *debug-log* "~%dump error: ~a~%" c))))

(defun start (server &key (async nil))
  (unless *cartridge*
    (error "(setq plastic-toy-gun:*cartrige* #'your-ink)~%"))
  (format *debug-log* "start server~%")
  (let ((sock '())
        (proc (lambda ()
                (unwind-protect
                    (loop (setq sock (accept server))
                          (bordeaux-threads:make-thread
                           (lambda ()
                             (handler sock)))))
                (dispose server))))
    (if async
        (bordeaux-threads:make-thread proc)
      (funcall proc))))
        
