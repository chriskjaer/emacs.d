(setq load-prefer-newer t)              ; Don't load outdated byte code

(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/")
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

(use-package evil                       ; Evil - VI for Emacs
  :ensure t
  :init
  (evil-mode 1)
  :config
  (setq evil-shift-width 2)
  (use-package linum-relative           ; Relative Line Numbers
    :ensure t
    :config
    (add-hook 'evil-insert-state-entry-hook 'linum-relative-toggle)
    (add-hook 'evil-insert-state-exit-hook 'linum-relative-toggle))
  (use-package evil-matchit             ; vi-% for more than {[""]}
    :ensure t
    :init
    (global-evil-matchit-mode 1))
  (use-package evil-nerd-commenter      ; Nerdcommenter for emacs
    :ensure t)
  (use-package evil-surround            ; Exactly like tpopes vim-surround
    :ensure t
    :init
    (global-evil-surround-mode))
  (use-package evil-leader              ; Leader key for evil
    :ensure t
    :init
    (global-evil-leader-mode)
    :config
    (key-chord-define evil-insert-state-map "jj" 'evil-normal-state)
    (evil-leader/set-leader "<SPC>")
    (evil-leader/set-key
      ;; Git
      "gs"    'magit-status

      ;; Projectile
      "pp"    'projectile-switch-project
      "pf"    'projectile-find-file
      "pb"    'projectile-buffers-with-file

      ;; Helper stuff
      "hc"    'describe-char
      "hf"    'describe-function
      "hk"    'describe-key
      "hm"    'describe-mode
      "hp"    'describe-package
      "ht"    'describe-theme
      "hv"    'describe-variable

      ;; Files
      "fw"    'save-buffer
      "fs"    'save-buffer
      "ff"    'find-file
      "fj"    'dired-jump

      ;; Init file
      "if"    'find-init-file
      "ir"    'reload-init-file

      ;; Buffer
      "bx"    'eval-buffer
      "bf"    'switch-to-buffer

      ;; Errors
      "el"    'flycheck-list-errors

      ;; Misc
      "<SPC>" 'switch-to-last-used-buffer

      ","     'evilnc-comment-operator
      "x"     'save-buffers-kill-terminal)))

(use-package flyspell                      ; Spellchecking
  :defer t)

(use-package powerline                     ; Vim Powerline - for Emacs
  :demand
  :disabled t
  :ensure t)

(use-package moe-theme                     ; Theme
  :ensure t
  :disabled t
  :config
  (load-theme 'moe-dark t))

(use-package darktooth-theme               ; Theme
  :ensure t
  :config
  (load-theme 'darktooth t))

;; Company-mode
(use-package company                       ; Autocomplete
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
(use-package markdown-mode                ; Markdown
  :ensure t)


;; Golden Ratio
(use-package golden-ratio                 ; Auto resize windows
  :ensure t
  :diminish golden-ratio-mode
  :init
  (golden-ratio-mode 1)
  (setq golden-ratio-auto-scale t)
  :config
  (setq golden-ratio-extra-commands
        (append golden-ratio-extra-commands
                '(evil-window-left
                  evil-window-right
                  evil-window-up
                  evil-window-down))))


(use-package winner                       ; undo/redo for you window configuration (C-c <left>)
  :init (winner-mode t))


(use-package projectile                   ; Awesome project handling
  :ensure t
  :diminish projectile-mode
  :bind ("M-p" . projectile-find-file)
  :init
  (projectile-global-mode))

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

(use-package ido-vertical-mode
  :ensure t
  :init
  (ido-vertical-mode 1))

(use-package smex                         ; ido for M-x
  ;:disabled t
  :ensure t
  :bind ("M-x" . smex)
  :init
  (smex-initialize))

;; magit
(use-package magit                        ; Awesome git frontend - like tpopes git-fugitive on steroids
  :ensure t)

;; Shell
(use-package shell                        ; Shell shortcut settings
  :bind ("C-c s" . shell)
  :init
  (dirtrack-mode)
  (setq explicit-shell-file-name (cond ((eq system-type 'darwin) "/usr/local/bin/zsh")))
  (when (eq system-type 'darwin)
    (use-package exec-path-from-shell
      :ensure t
      :init
      (exec-path-from-shell-initialize))))

(use-package smooth-scrolling             ; Scroll like VI
  :ensure t
  :config
  (setq smooth-scroll-margin 3))

(use-package smartparens                  ; Autoclosing stuff. Better than `electric-mode' most of the time.
  :ensure t
  :diminish smartparens-mode
  :config
  (smartparens-global-mode)
  (progn
     (defun my-elixir-do-end-close-action (id action context)
       (when (eq action 'insert)
         (newline-and-indent)
         (previous-line)
         (indent-according-to-mode)))

     (sp-with-modes '(elixir-mode)
       (sp-local-pair "do" "end"
                      :when '(("SPC" "RET"))
                      :post-handlers '(:add my-elixir-do-end-close-action)
                      :actions '(insert)))))


(when (eq system-type 'darwin)            ; Better copy paste on mac
  (use-package pbcopy
    :ensure t
    :config (turn-on-pbcopy)))

(use-package flycheck                     ; On-the-fly syntax checking / linting
  :ensure t
  :diminish flycheck-mode
  :bind ("C-c l e" . flycheck-list-errors)
  :init (global-flycheck-mode)
  :config
  (setq-default flycheck-disabled-checkers
                (append flycheck-disabled-checkers
                        '(javascript-jshint)))
  (flycheck-add-mode 'javascript-eslint 'web-mode))

(use-package yasnippet                   ; Snippets
  :ensure t
  :defer 2
  :diminish yas-minor-mode
  :config
  (setq yas-snippet-dirs
        '("~/.emacs.d/snippets"
          "~/.emacs.d/yasnippet-snippets"))
  (yas-global-mode 1))



;;; Languages
(use-package js2-mode                   ; Javascript
  :ensure t
  :mode (("\\.jsx?\\'" . js2-mode))
  :commands (j2-mode))

(use-package json-mode                  ; JSON
  :ensure t
  :mode (("\\.json\\'" . json-mode))
  :commands (json-mode))

(use-package web-mode                   ; Templates
  :ensure t
  :mode (("\\.html?\\'" . web-mode)
         ("\\.eex\\'"   . web-mode))
  :config
  (local-set-key (kbd "RET") 'newline-and-indent))


(use-package elixir-mode                ; Elixer
  :ensure t
  :mode (("\\.exs?\\'"   . elixir-mode)
         ("\\.elixer\\'" . elixir-mode))
  :config
  (add-to-list 'elixir-mode-hook
               (defun auto-activate-ruby-end-mode-for-elixir-mode ()
                 (set (make-variable-buffer-local 'ruby-end-expand-keywords-before-re)
                      "\\(?:^\\|\\s-+\\)\\(?:do\\)")
                 (set (make-variable-buffer-local 'ruby-end-check-statement-modifiers) nil)
                 (ruby-end-mode +1)))
  (use-package alchemist
    :ensure t))





;; --- General Settings ----------------------------------------

;; UI Stuff
(tool-bar-mode -1)
(menu-bar-mode 1)
(scroll-bar-mode -1)
(column-number-mode -1)
(global-linum-mode t)
(line-number-mode t)
(show-paren-mode 1) ;; Show matching parentheses
(setq blink-matching-paren nil) ;; Highlighted parentheses are nice, but you don't have to flash them...
(blink-cursor-mode 0)
(set-frame-font "Menlo 14")
(setq default-frame-alist '((font . "Menlo 14")))

;; Highlight cursor line
(global-hl-line-mode t)

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

;(electric-pair-mode 1) ;; auto pairs

;; switch alt and super on mac
(when (eq system-type 'darwin)
  (setq mac-command-modifier 'meta
        mac-option-modifier 'super
        mac-control-modifier 'control
        ns-function-modifier 'hyper))

;; Move autosave and backup files to temp dir.
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

;;; init.el ends here
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("ca9d9cf1d550a6296db85048aebd07e982d3ce2e52727e431809fa579f5c8ebb" default)))
 '(pos-tip-background-color "#36473A")
 '(pos-tip-foreground-color "#FFFFC8"))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
