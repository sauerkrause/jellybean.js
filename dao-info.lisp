(defclass dao-info ()
  ((dbname :initarg :dbname
	   :reader dao-info-dbname)
   (username :initarg :username
	     :reader dao-info-username)
   (password :initarg :password
	     :reader dao-info-password)
   (hostname :initarg :host
	     :reader dao-info-hostname)))

(defun connect-info (dao)
  (list (dao-info-dbname dao)
	(dao-info-username dao)
	(dao-info-password dao)
	(dao-info-hostname dao)))