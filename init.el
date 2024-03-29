;;; init.el --- Init setup
;; Load manually, the melpa package doesn't contain restclient-jq
;;
;;; Commentary:
;; ______                 _      _____
;; | ___ \               | |    |  ___|
;; | |_/ /_   _ _ __ __ _| | __ | |__ _ __ ___   __ _  ___ ___
;; | ___ \ | | | '__/ _` | |/ / |  __| '_ ` _ \ / _` |/ __/ __|
;; | |_/ / |_| | | | (_| |   <  | |__| | | | | | (_| | (__\__ \
;; \____/ \__,_|_|  \__,_|_|\_\ \____/_| |_| |_|\__,_|\___|___/
;;
;;
;;
;;  Init config. Only load package that needs to be loaded before all modules.

;;; Code:

(package-initialize)
(setq use-package-always-ensure t)

(defun is-mac-p ()
  "If it's mac os."
  (eq system-type 'darwin))

(defun is-linux-p ()
  "If it's GNU/Linux."
  (eq system-type 'gnu/linux))

(defun is-windows-p ()
  "If it's based on Windows."
  (or
   (eq system-type 'ms-dos)
   (eq system-type 'windows-nt)
   (eq system-type 'cygwin)))

(defun is-bsd-p ()
  "If it's BSD."
  (eq system-type 'gnu/kfreebsd))

(when (is-mac-p)
  (add-to-list 'exec-path "/usr/local/bin/")
  (add-to-list 'exec-path "/usr/bin/"))

(when (is-linux-p)
  (add-to-list 'exec-path "/usr/local/bin/")
  (add-to-list 'exec-path "/usr/bin/")
  (add-to-list 'exec-path "~/.sdkman/candidates/sbt/current/bin/")
  )

(unless (assoc-default "melpa" package-archives)
  (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t))
(unless (assoc-default "org" package-archives)
  (add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/") t))

(add-to-list 'load-path (concat user-emacs-directory "modules"))
(add-to-list 'load-path (concat user-emacs-directory "lisp"))

;; update packages list if we are on a new install
(unless package-archive-contents
  (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(setq use-package-verbose t)
(setq use-package-always-ensure t)
(require 'use-package)
(use-package auto-compile
  :config (auto-compile-on-load-mode))
(setq load-prefer-newer t)

;; Remove warning
(setq byte-compile-warnings '(cl-functions))

;; I don't care about auto save and backup files.
(setq
 make-backup-files nil  ; stop creating backup~ files
 auto-save-default nil  ; stop creating #autosave# files
 create-lockfiles nil)  ; stop creating .# files

;; Delete trailing spaces and add new line in the end of a file on save.
(add-hook 'before-save-hook 'delete-trailing-whitespace)
(setq require-final-newline t)

;; Ensure correct indentation for use-package.
(put 'use-package 'lisp-indent-function 1)

;; Save customize in separate file
(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)

(use-package general
    :init
    (setq general-override-states '(insert
				    emacs
				    hybrid
				    normal
				    visual
				    motion
				    operator
				    replace)))

(use-package no-littering)
(use-package delight
  :config
  (delight 'visual-line-mode))
(use-package bind-key)
(use-package which-key
  :config
  (add-hook 'after-init-hook 'which-key-mode))

;; Loading modules
(require 'python.module)
(require 'web.module)
(require 'java.module)
(require 'scala.module)
(require 'utils.module)
(require 'org.module)
(require 'sx.module)
(require 'tree.module)
(require 'core.module)
(require 'hydra.module)
(require 'dap.module)
(require 'handy-functions)
(require 'dash.module)
(require 'popper.module)
(require 'key-bindings.module)

(provide 'init)

;;; init ends here
