;;; Begin initialization
;; Turn off mouse interface early in startup to avoid momentary display
(when window-system
  (menu-bar-mode -1)
  (tool-bar-mode -1)
  (scroll-bar-mode -1)
  (tooltip-mode -1))

(setq inhibit-startup-screen t)
(setq inhibit-startup-message t)

;; Removes *scratch* from buffer after the mode has been set.
;(defun remove-scratch-buffer ()
;  (if (get-buffer "*scratch*")
;      (kill-buffer "*scratch*")))
;(add-hook 'after-change-major-mode-hook 'remove-scratch-buffer)

;;; Set up package
(when (>= emacs-major-version 24)
  (require 'package)
  (package-initialize)
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/") t)
  (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
  )

;;; Bootstrap use-package
;; Install use-package if it's not already installed.
;; use-package is used to configure the rest of the packages.
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
;; From use-package README
(eval-when-compile
  (require 'use-package))

;; Let our config file find pre-installed packages
(add-to-list 'load-path "~")
(add-to-list 'load-path "~/.emacs.d/elpa/")
(add-to-list 'load-path "~/.emacs.d/lisp/")

;;; Load the config
(org-babel-load-file (concat user-emacs-directory "config.org"))

;;(find-file "~/todo.org")
;;(make-buffer-uninteresting)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(lua-mode nyx-theme spacemacs-theme tide tabbar csharp-mode racket-mode web-mode helm company tern neotree all-the-icons-dired dired-sidebar rjsx-mode racer rust-mode dumb-jump auto-complete-clang use-package pabbrev org-plus-contrib cyberpunk-theme cmake-mode)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(if (get-buffer "*Messages*")
	(kill-buffer "*Messages*"))
(if (get-buffer "*Shell Configuration*")
	(kill-buffer "*Shell Configuration*"))
