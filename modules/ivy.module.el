;;; ivy.module.el --- Ivy is a powerful alternative to the popular helm

;;; Commentary:

;; Ivy-related config.  This module contain Ivy configuration and related package.
;; like counsel and avy

;;; Code:

(defhydra hydra-folding ()
  "folding"
  ("C" origami-close-all-nodes "close all")
  ("O" origami-open-all-nodes "open all")
  ("c" origami-close-node "close")
  ("o" origami-open-node "open"))

(use-package posframe)

(use-package ivy
  :config
  ;; (setq ivy-use-virtual-buffers t)
  (setq ivy-count-format "(%d%d)")
  (ivy-mode 1))

;; TODO I need to think again about the binding to C-x here
(use-package counsel
  :bind (("M-x" . counsel-M-x)
         ("C-x b" . counsel-ibuffer)
         ("C-c C-r" . ivy-resume)
         ("C-x C-f" . counsel-find-file)
         ("C-c a" . counsel-ag)
         ("C-c g" . counsel-git)
         ("C-c j" . counsel-git-grep)
         ("C-c l" . counsel-locate)
         :map minibuffer-local-map
         ("C-h" . 'counsel-minibuffer-history))
  :init
  (ivy-mode 1)
  (counsel-mode 1)
  :config
  (setq ivy-use-virtual-buffers t)
  (setq enable-recursive-minibuffers t)
  (setq ivy-initial-inputs-alist nil)) ;; Don't start searches with ^ !

(use-package ivy-xref
  :after ivy
  :init
  (setq xref-show-xrefs-function #'ivy-xref-show-xrefs))

(use-package ivy-rich
  :after ivy
  :init
  (ivy-rich-mode 1))

(use-package ivy-prescient
  :after counsel
  :init
  (ivy-prescient-mode)
  (prescient-persist-mode)
  )

(use-package ivy-posframe
  :after ivy
  :config
  (setq ivy-posframe-display-functions-alist
        '(
          (t . ivy-posframe-display-at-frame-center)
          (swiper . ivy-display-function-fallback)
          (complete-symbol . ivy-posframe-display-at-point))
        ivy-posframe-parameters '((left-fringe . 8)
                                  (right-fringe . 8)))
  (ivy-posframe-mode 1))

(use-package prescient
  :diminish)

(use-package counsel-ag-popup
  :after (counsel))

(use-package counsel-projectile
  :after (counsel projectile)
  :config
  (counsel-projectile-mode 1))

(add-to-list 'ivy-height-alist
             (cons 'counsel-find-file
                   (lambda (_caller)
                     (/ (frame-height) 2))))

(setq ivy-height-alist
      '((t
         lambda (_caller)
         (/ (frame-height) 2))))

(defun ivy-resize--minibuffer-setup-hook ()
  "Minibuffer setup hook."
  (add-hook 'post-command-hook #'ivy-resize--post-command-hook nil t))

(defun ivy-resize--post-command-hook ()
  "Hook run every command in minibuffer."
  (when ivy-mode
    (shrink-window (1+ ivy-height))))  ; Plus 1 for the input field.

(add-hook 'minibuffer-setup-hook 'ivy-resize--minibuffer-setup-hook)

;; Jump to things in Emacs tree-style
(use-package avy
  :ensure t
  :bind(("C-:" . avy-goto-word-1)
        :map isearch-mode-map
              ("C-'" . avy-isearch)))

(use-package ivy-hydra)

;; Show ivy frame using posframe
(use-package ivy-posframe
  :config
  (ivy-posframe-mode 1)
  :custom
  (ivy-display-function #'ivy-posframe-display-at-frame-center)
  ;; (ivy-posframe-width 130)
  ;; (ivy-posframe-height 11)
  (ivy-posframe-parameters
   '((left-fringe . 5)
     (right-fringe . 5)))
  :custom-face
  (ivy-posframe ((t (:background "#282a36"))))
  (ivy-posframe-border ((t (:background "#6272a4"))))
  (ivy-posframe-cursor ((t (:background "#61bfff"))))
  )

(use-package swiper
  :bind (("C-s" . swiper)
         :map ivy-minibuffer-map
         ("C-SPC" . ivy-restrict-to-matches))
  :init
  (ivy-mode 1)
  :config
  (setq ivy-count-format "(%d/%d) "
        ivy-display-style 'fancy
        ivy-height 4
        ivy-use-virtual-buffers t
        ivy-initial-inputs-alist () ;; http://irreal.org/blog/?p=6512
        enable-recursive-minibuffers t))

(provide 'ivy.module)
;;; ivy.module.el ends here
