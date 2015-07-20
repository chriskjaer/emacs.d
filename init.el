(global-linum-mode t)

(require 'package)

(setq package-enable-at-startup nil)

(package-initialize)

(require 'cask "/usr/local/share/emacs/site-lisp/cask.el")

(cask-initialize)



;;; Evil
(require 'evil)
(evil-mode t)



;;; GUI
(tool-bar-mode -1)
(scroll-bar-mode -1)



;;; Misc
(setq make-backup-files nil)
(setq ring-bell-function 'ignore)



;;; Theme
(load-theme 'wombat)



;;; ido
(require 'flx-ido)
(ido-mode 1)
(ido-everywhere 1)
(flx-ido-mode 1)
;;; disable ido faces to see flx highlights.
(setq ido-enable-flex-matching t)
(setq ido-use-faces nil)

(setq ido-decorations
      (quote ("\n↪ "     "" "\n   " "\n   ..." "[" "]" " [No match]" " [Matched]" " [Not readable]" " [Too big]" " [Confirm]")))
