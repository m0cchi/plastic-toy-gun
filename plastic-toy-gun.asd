#|
URL: https://github.com/mocchit/toy-gun
Author: mocchit
|#

(in-package :cl-user)
(defpackage plastic-toy-gun-asd
  (:use :cl :asdf))
(in-package :plastic-toy-gun-asd)

(defsystem plastic-toy-gun
  :version "0.0.1"
  :author "mocchi"
  :license "BSD License"
  :depends-on (:usocket
               :bordeaux-threads)
  :components ((:module "src"
                        :components
                ((:file "plastic-toy-gun"))))
  :description "abstract server")
