(require 'ningle)
(require 'cl-postgres)
(require 'postmodern)

(load "init-package.lisp")
(in-package :jellybean-js)
(defvar *app* (make-instance '<app>))

(clackup *app* :port 8000)
(load "dao.lisp")
(load "server.lisp")
