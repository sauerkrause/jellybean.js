(in-package :rest-api)

(setf (route *app* "/")
       "GO AWAY")

;; Returns the number of jellybeans belonging to a name
(defun jellybeans (name &optional number)
  (let ((name (string-upcase name)))
    (with-connection (connect-info *credentials*)
		     (let ((user (get-dao 'user name)))
		       (unless user (setf user (make-instance 'user :name name
							      :points 0
							      :jellybeans 5)))
		       (when number
			 (setf (user-jellybeans user) (+ number (user-jellybeans user))))
		       (save-dao user)
		       (format nil "~a" (user-jellybeans user))))))


;; Returns the number of points belonging to a name
(defun points (name &optional number)
  (let ((name (string-upcase name)))
    (with-connection (connect-info *credentials*)
		     (let ((user (get-dao 'user name)))
		       (unless user (setf user (make-instance 'user :name name
							      :points 0
							      :jellybeans 5)))
		       (when number
			 (setf (user-points user) (+ number (user-points user))))
		       (save-dao user)
		       (format nil "~a" (user-points user))))))

;; Gets url for a given name
(setf (route *app* "/:name" :method :GET)
      #'(lambda (params)
	  (with-connection (connect-info *credentials*)
	    (let ((upcase-name (string-upcase (getf params :name))))
	      (if (get-dao 'user upcase-name)
		  (format nil "~a~%~a~%"
			  (format nil "/~a/points" upcase-name)
			  (format nil "/~a/jellybeans" upcase-name))
		(progn (setf (clack.response:status *response*) 404)
		       "Not found"))))))

(defun name-exists (name)
  (with-connection (connect-info *credentials*)
		   (let ((upcase-name (string-upcase name)))
		     (get-dao 'user upcase-name))))

;; Gets points for a given name
(setf (route *app* "/:name/points" :method :GET)
      #'(lambda (params)
	  (let ((name (getf params :name)))
	    (if (name-exists name)
		(points (getf params :name))
	      (progn (setf (clack.response:status *response*) 404)
		     "0")))))

;; Gets jellybeans for a given name
(setf (route *app* "/:name/jellybeans" :method :GET)
      #'(lambda (params)
	  (let ((name (getf params :name)))
	    (if (name-exists name)
		(jellybeans (getf params :name))
	      (progn (setf (clack.response:status *response*) 404)
		     "0" )))))

;; Posts points to a given name
(setf (route *app* "/:name/points" :method :POST)
      #'(lambda (params)
	  (points (getf params :name)
		  (parse-integer (getf params :|number|)))))
;; Posts jellybeans to the given name
(setf (route *app* "/:name/jellybeans" :method :POST)
      #'(lambda (params)
	  (jellybeans (getf params :name)
		      (parse-integer (getf params :|number|)))))
