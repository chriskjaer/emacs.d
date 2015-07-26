;; Don't load outdated byte code
(setq load-prefer-newer t)

(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives
            ;'("melpa" . "http://melpa.org/packages/")
             '("melpa-stable" . "http://stable.melpa.org/packages/"))

(package-initialize)

;; Bootstrap `use-package'
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;;; Requires
(eval-when-compile
  (require 'use-package))

(use-package bug-hunter                 ; Search init file for bugs
  :ensure t)

;; Key-chord
(use-package key-chord
  :demand t
  :ensure t
  :init
  (key-chord-mode 1))


;; Thanks http://emacsredux.com/blog/2013/05/18/instant-access-to-init-dot-el/
(defun find-init-file ()
  "Edit the `user-init-file', in another window."
  (interactive)
  (find-file-other-window user-init-file))

(defun reload-init-file ()
  "Reload my init file."
  (interactive)
  (load-file user-init-file))

(defun switch-to-last-used-buffer ()
  (interactive)
  (switch-to-buffer (other-buffer)))


;; Evil
(use-package evil
  :ensure t
  :init
  (evil-mode 1)
  :config
  (use-package evil-leader
  :ensure t
  :init
  (global-evil-leader-mode)
  :config
  (key-chord-define evil-insert-state-map "jj" 'evil-normal-state)
  (evil-leader/set-leader "<SPC>")
  (evil-leader/set-key
      "<SPC>" 'switch-to-last-used-buffer
      "w" 'save-buffer
      "fi" 'find-init-file
      "ri" 'reload-init-file
      "bx" 'eval-buffer)))

;; Flyspell
(use-package flyspell
  :defer t)

(use-package powerline
  :demand
  :ensure t)

;; Theme
(use-package moe-theme
  :ensure t
  :config
  (load-theme 'moe-dark t))

;; Company-mode
(use-package company
  :ensure t
  :diminish company-mode
  :bind ("C-." . company-complete)
  :init
  (global-company-mode 1)
  :config
  (bind-keys :map company-active-map
             ("C-j" . company-select-next)
             ("C-k" . company-select-previous)
             ("C-d" . company-show-doc-buffer)
             ("<tab>" . company-complete)))

;; Markdown
(use-package markdown-mode
  :ensure t)


;; Golden Ratio
(use-package golden-ratio
  :ensure t
  :diminish golden-ratio-mode
  :init
  (golden-ratio-mode 1)
  (setq golden-ratio-auto-scale t))

;; Winner mode -- undo/redo for you window configuration (C-c <LEFT>)
(use-package winner
  :init (winner-mode t))


;; Helm & Projectile & Perspective & Ido
(use-package projectile
  :ensure t
  :bind ("M-p" . projectile-find-file)
  :init
  (projectile-global-mode))

(use-package ido-vertical-mode
  :ensure t
  :init
  (ido-vertical-mode 1))

(use-package ido
  :init
  (ido-mode 1)
  (ido-everywhere 1)
  :config
  (use-package flx-ido
    :ensure t
    :config
    (flx-ido-mode 1)
    (setq ido-enable-flex-matching t
          ido-use-faces nil)))

;; ido for M-x
(use-package smex
  ;:disabled t
  :ensure t
  :bind ("M-x" . smex)
  :init
  (smex-initialize))

;; magit
(use-package magit
  :ensure t
  :bind ("C-c g" . magit-status))

;; Languages
(use-package js2-mode
  :ensure t
  :mode (("\\.jsx?\\'" . js2-mode)
         ("\\.json\\'" . js2-mode))
  :commands (j2-mode))

(use-package web-mode
  :ensure t
  :mode (("\\.html?\\'" . web-mode))
  :config
  (local-set-key (kbd "RET") 'newline-and-indent))


;; Settings

;; UI Stuff
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(column-number-mode -1)
(line-number-mode t)
(show-paren-mode 1) ;; Show matching parentheses
(setq blink-matching-paren nil) ;; Highlighted parentheses are nice, but you don't have to flash them...
(blink-cursor-mode 0)
(set-frame-font "Menlo 14")
(setq default-frame-alist '((font . "Menlo 14")))

;; Set that fringe
(setq window-combination-resize t)
(setq-default fringe-indicator-alist
              '((truncation . nil) (continuation . nil)))

;; 80 Char column lines
(setq-default fill-column 80
              whitespace-line-column 80)

;; Tabs
;; Two space. No tabs
(setq-default indent-tabs-mode nil
              tab-width 2)
(setq tab-always-indent 'complete) ;; Tab should always indent

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

;; Modeline
(display-time-mode 1)
(setq display-time-format "%a %m/%d%t%R")

;; Misc

;; Startup stuff
(setq inhibit-splash-screen t              ;; remove splash screen
      inhibit-startup-echo-area-message t
      inhibit-startup-message t
      initial-scratch-message "")

(setq make-backup-files nil)
(setq ring-bell-function 'ignore)
(setq longlines-show-hard-newlines t)

(fset 'yes-or-no-p 'y-or-n-p) ;; Enable y-n answers instead of writing everything.
(global-visual-line-mode t)
(global-auto-revert-mode t) ;; Auto reload buffers if files changes outside of emacs

(electric-pair-mode 1) ;; auto pairs

;; switch alt and super on mac
(setq ns-function-modifier 'hyper)
(setq mac-command-modifier 'meta)
(setq mac-option-modifier 'super)

;; Move autosave and backup files to temp dir.
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))
