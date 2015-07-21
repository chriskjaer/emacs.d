(require 'package)

(setq package-enable-at-startup nil)

(package-initialize)

(require 'cask "/usr/local/share/emacs/site-lisp/cask.el")

(cask-initialize)



;;; Evil
(require 'evil)
(evil-mode t)



;;; GUI Niceness
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(column-number-mode -1)
(line-number-mode t)

;; 80 Char column lines
(setq-default fill-column 80
              whitespace-line-column 80)

;; Two space. No tabs
(setq-default indent-tabs-mode nil
              tab-width 2)

;; Remove trailing whitespace on save
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; Whitespace rules
(setq whitespace-style '(indentation::space
                         space-after-tab
                         space-before-tab
                         trailing
                         lines-tail
                         tab-mark
                         face
                         tabs))

;;; Misc
(setq make-backup-files nil)
(setq ring-bell-function 'ignore)
(setq inhibit-splash-screen t) ;; remove splash screen

;; Move autosave and backup files to temp dir.
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

;;; Theme
(load-theme 'wombat)



;;; ido
(require 'flx-ido)
(ido-mode 1)
(ido-everywhere 1)
(flx-ido-mode 1)
(setq ido-enable-flex-matching t) ;; disable ido faces to see flx highlights.
(setq ido-use-faces nil)
(setq ido-decorations
      (quote ("\n↪ "     "" "\n   " "\n   ..." "[" "]" " [No match]" " [Matched]" " [Not readable]" " [Too big]" " [Confirm]")))
