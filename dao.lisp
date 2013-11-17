(in-package :jellybean-js)
(load "dao-info.lisp")
(load "dao-credentials.lisp")
(defclass user ()
  ((name
    :col-type string :initarg :name
    :reader user-name)
   (points
    :col-type integer :initarg :points
	   :accessor user-points)
   (jellybeans
    :col-type integer :initarg :jellybeans
	       :accessor user-jellybeans))
  (:metaclass dao-class)
  (:keys name))
