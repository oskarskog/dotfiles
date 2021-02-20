;;; init.el --- Emacs init file
;;; Commentary:
;;; Simple config
;;; Code:
(defvar file-name-handler-alist-original file-name-handler-alist)

(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.6
      file-name-handler-alist nil
      site-run-file nil)

(defvar ian/gc-cons-threshold 100000000)

(add-hook 'emacs-startup-hook ; hook run after loading init files
          (lambda ()
            (setq gc-cons-threshold ian/gc-cons-threshold
                  gc-cons-percentage 0.1
                  file-name-handler-alist file-name-handler-alist-original
                  read-process-output-max (* 1024 1024))))

(add-hook 'minibuffer-setup-hook (lambda ()
                                   (setq gc-cons-threshold (* ian/gc-cons-threshold 2))))
(add-hook 'minibuffer-exit-hook (lambda ()
                                  (garbage-collect)
                                  (setq gc-cons-threshold ian/gc-cons-threshold)))

;; workaround bug in Emacs 26.2
(defvar gnutls-algorithm-priority)
(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")

;; disable warnings about cl-package
(setq byte-compile-warnings '(cl-functions))

;; Set up straight for git package management
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;; Setting up the package manager. Install if missing.
(straight-use-package 'use-package)
(require 'straight-x)

(use-package diminish
  :straight t
  :demand t)

;; disable meta on OSX
(when (memq window-system '(mac ns x))
  (setq ns-alternate-modifier 'none)
  (setq ns-right-alternate-modifier 'none))

;; Boilerplate stuff
(setq inhibit-startup-screen t)
(use-package emacs
  :preface
  (defvar ian/indent-width 4)
  :config
  (setq frame-title-format '("Emacs")
        ring-bell-function 'ignore
        frame-resize-pixelwise t
        default-directory "~/")

  (tool-bar-mode -1)
  (menu-bar-mode -1)
  (auto-save-mode nil)
  (blink-cursor-mode -1)

  ;; better scrolling experience
  (setq scroll-margin 0
        scroll-conservatively 101 ; > 100
        scroll-preserve-screen-position t
        auto-window-vscroll nil)

  ;; Always use spaces for indentation
  (setq-default indent-tabs-mode nil
                tab-width ian/indent-width))

(use-package delsel
  :config (delete-selection-mode +1))

(use-package scroll-bar
  :config (scroll-bar-mode -1))

(use-package simple
  :config (column-number-mode +1))

(use-package uniquify
  :config (setq uniquify-buffer-name-style 'post-forward))

(use-package files
  :config
  (setq confirm-kill-processes nil
        create-lockfiles nil ; don't create .# files (crashes 'npm start')
        make-backup-files nil))

(use-package autorevert
  :config
  (global-auto-revert-mode +1)
  (setq auto-revert-interval 2
        auto-revert-check-vc-info t
        global-auto-revert-non-file-buffers t
        auto-revert-verbose nil))


(use-package cc-vars
  :config
  (setq-default c-basic-offset ian/indent-width)
  (setq c-default-style '((java-mode . "java")
                          (awk-mode . "awk")
                          (other . "k&r"))))

;; Python (both v2 and v3)
(use-package python
  :config (setq python-indent-offset ian/indent-width))


(use-package mwheel
  :config (setq mouse-wheel-scroll-amount '(2 ((shift) . 1))
                mouse-wheel-progressive-speed nil))

(use-package paren
  :init (setq show-paren-delay 0)
  :config (show-paren-mode +1))

(use-package frame
  :preface
  (defun ian/set-default-font ()
    (interactive)
    (when (member "Iosevka" (font-family-list))
      (set-face-attribute 'default nil
                          :family "Iosevka"
                          :height 140
                          :weight 'normal)))
  :config
  (setq initial-frame-alist '(
                              (width . 140)
                              (height . 60)))
  (ian/set-default-font))

(use-package ediff
  :config
  (setq ediff-window-setup-function #'ediff-setup-windows-plain)
  (setq ediff-split-window-function #'split-window-horizontally))

(use-package elec-pair
  :hook (prog-mode . electric-pair-mode))

(use-package whitespace
  :hook (before-save . whitespace-cleanup))

(use-package dired
  :config
  (setq delete-by-moving-to-trash t)
  (eval-after-load "dired"
    #'(lambda ()
        (put 'dired-find-alternate-file 'disabled nil)
        (define-key dired-mode-map (kbd "RET") #'dired-find-alternate-file))))

(use-package cus-edit
  :config
  (setq custom-file (concat user-emacs-directory "to-be-dumped.el")))

(use-package hl-line
  :config (global-hl-line-mode))

(use-package eldoc
  :diminish eldoc-mode
  :config
  (setq eldoc-idle-delay 0.4))

(use-package recentf
  :config
  (setq recentf-max-menu-items 20))

;; Thirdparty

(use-package restart-emacs
  :straight t
  :commands (restart-emacs))

(use-package hungry-delete
  :straight t
  :hook (prog-mode . hungry-delete-mode))

(use-package all-the-icons
  :straight t)

;; Themes
(use-package spacemacs-theme
  :defer t
  :straight t
  :init
  (setq spacemacs-theme-comment-italic t
        spacemacs-theme-comment-bg nil)
  (load-theme 'spacemacs-dark t))

(use-package highlight-numbers
  :straight t
  :hook (prog-mode . highlight-numbers-mode))

(use-package highlight-escape-sequences
  :straight t
  :hook (prog-mode . hes-mode))

(use-package undo-tree
  :straight t
  :diminish undo-tree-mode
  :config
  (global-undo-tree-mode))

(use-package evil
  :straight t
  :init
  (setq evil-want-C-u-scroll t
        evil-undo-system 'undo-tree
        evil-want-keybinding nil
        evil-shift-width ian/indent-width)
  :hook (after-init . evil-mode)
  :preface
  (defun ian/save-and-kill-this-buffer ()
    (interactive)
    (save-buffer)
    (kill-this-buffer))
  :config
  (with-eval-after-load 'evil-maps ; avoid conflict with company tooltip selection
    (evil-define-key 'normal 'global (kbd "C-h") 'evil-window-left)
    (evil-define-key 'normal 'global (kbd "C-j") 'evil-window-down)
    (evil-define-key 'normal 'global (kbd "C-k") 'evil-window-up)
    (evil-define-key 'normal 'global (kbd "C-l") 'evil-window-right)
    (define-key evil-insert-state-map (kbd "C-n") nil)
    (define-key evil-insert-state-map (kbd "C-p") nil)))

(use-package evil-collection
  :straight t
  :after evil
  :config
  (setq evil-collection-company-use-tng nil)
  (evil-collection-init))

(use-package evil-commentary
  :straight t
  :after evil
  :diminish evil-commentary-mode
  :config (evil-commentary-mode +1))

(use-package evil-leader
  :straight t
  :preface
  (defun os/switch-to-last-buffer ()
    (interactive)
    (switch-to-buffer nil))
  :config
  (evil-leader/set-leader "SPC")
  (global-evil-leader-mode)
  (evil-leader/set-key
    "TAB" 'os/switch-to-last-buffer
    "o" 'delete-other-windows
    "E" 'eval-region
    "df" 'describe-function
    "dv" 'describe-variable
    "dm" 'describe-mode))

(use-package evil-easymotion
  :straight t
  :config (evilem-default-keybindings ","))

(use-package org
  :straight t
  :hook ((org-mode . visual-line-mode)
         (org-mode . org-indent-mode))
  :config
  (setq-local org-return-follows-link t)
  (setq org-src-tab-acts-natively t
        org-src-preserve-indentation t
        org-confirm-babel-evaluate nil)
  (org-babel-do-load-languages
   'org-babel-load-languages '((emacs-lisp . t)
                               (python . t)
                               (restclient . t)
                               (shell . t)))
  (evil-leader/set-key-for-mode 'org-mode
    "me" 'org-babel-execute-src-block
    "mt" 'org-todo
    "md" 'org-time-stamp
    "mn" 'org-add-note
    "mb" 'browse-url)
  (require 'org-tempo))

(use-package magit
  :straight t
  :config
  (evil-define-key 'normal 'magit-status-mode-map (kbd "C-h") 'evil-window-left)
  (evil-define-key 'normal 'magit-status-mode-map (kbd "C-j") 'evil-window-down)
  (evil-define-key 'normal 'magit-status-mode-map (kbd "C-k") 'evil-window-up)
  (evil-define-key 'normal 'magit-status-mode-map (kbd "C-l") 'evil-window-right)
  (evil-leader/set-key
    "gg" 'magit-status
    "gf" 'magit-log-buffer-file
    "gb" 'magit-blame))

(use-package git-gutter-fringe
  :straight t
  :diminish git-gutter-mode
  :config
  (global-git-gutter-mode +1))

(use-package projectile
  :straight t
  :config
  (setq projectile-project-search-path (list "~/d/src"))
  (projectile-discover-projects-in-search-path)
  (evil-leader/set-key
    "pk" 'projectile-kill-buffers))

(use-package helm
  :straight t
  :bind (:map helm-map ("C-d" . 'helm-buffer-run-kill-buffers))
  :config
  (setq helm-split-window-default-side 'same)
  (evil-leader/set-key
    "e" 'helm-mini
    "fc" 'helm-M-x
    "fa" 'helm-apropos
    "ff" 'helm-find-files
    "fg" 'helm-google-suggest))

(use-package helm-ag
  :straight t
  :bind (:map helm-map ("C-c C-c" . 'helm-ag-edit))
  :config
  (setq helm-ag-insert-at-point 'symbol
        helm-ag-base-command (concat "ag"
                                     " --nocolor"
                                     " --nogroup"
                                     " --smart-case"))
  (evil-leader/set-key
    "fs" 'helm-do-ag-this-file))

(use-package helm-projectile
  :straight t
  :config
  (helm-projectile-on)
  (evil-leader/set-key
    "pf" 'helm-projectile
    "pF" 'helm-projectile-find-file-in-known-projects
    "ps" 'helm-projectile-switch-project
    "pr" 'helm-projectile-ag))

(use-package company
  :straight t
  :diminish company-mode
  :hook ((prog-mode . company-mode)
         (org-mode . company-mode))
  :config
  (setq company-minimum-prefix-length 1
        company-idle-delay 0.1
        company-selection-wrap-around t
        company-dabbrev-downcase nil
        company-tooltip-align-annotations t
        company-frontends '(company-pseudo-tooltip-frontend ; show tooltip even for single candidate
                            company-echo-metadata-frontend))
  (with-eval-after-load 'company
    (define-key company-active-map (kbd "C-n") 'company-select-next)
    (define-key company-active-map (kbd "C-p") 'company-select-previous)))

(use-package company-box
  :straight t
  :diminish company-box-mode
  :hook (company-mode . company-box-mode))

;; Prog modes

(use-package ruby-mode
  :config
  (setq ruby-insert-encoding-magic-comment nil))

(use-package inf-ruby
  :straight t
  :hook (ruby-mode . inf-ruby-minor-mode)
  :config
  (setq inf-ruby-default-implementation "jruby")
  (evil-leader/set-key-for-mode 'ruby-mode
    "mr" 'inf-ruby
    "me" 'ruby-send-region
    "md" 'ruby-send-definition))

(use-package js-comint
  :straight t
  :config
  (evil-leader/set-key-for-mode 'web-mode
    "mr" 'js-comint-repl
    "mR" 'js-comint-reset-repl
    "ms" 'js-comint-send-region))

(use-package typescript-mode
  :straight t)

(use-package web-mode
  :straight t
  :preface
  :mode (("\\.js\\'" . web-mode)
         ("\\.hbs\\'" . web-mode)
         ("\\.html\\'" . web-mode)
         ("\\.scss\\'" . web-mode)
         ("\\.css\\'" . web-mode))
  :hook ((web-mode . (lambda ()
                       (if (string= (file-name-extension (buffer-name)) "hbs")
                         (web-mode-set-engine "handlebars")
                         (setq-local web-mode-comment-style 2
                                     comment-start "{{!--"
                                     comment-end   "--}}")
                         (add-hook 'before-save-hook 'lsp-format-buffer nil 'local)))))
  :config
  (setq web-mode-block-padding 0
        web-mode-script-padding 0
        web-mode-style-padding 0
        web-mode-part-padding 0)
  (setq web-mode-indentation-params
        (seq-filter
         (lambda (elt)
           (let ((key (car elt)))
             (not (member key '("lineup-calls"
                                "lineup-args"
                                "lineup-ternary")))))
         web-mode-indentation-params)))

(use-package add-node-modules-path
  :straight t
  :hook (web-mode . add-node-modules-path))

(use-package coffee-mode
  :straight t)

(use-package nxml-mode
  :mode (("\\.xaml\\'" . nxml-mode)))

(use-package csharp-mode
  :straight t)

(use-package python
  :config
  (evil-leader/set-key-for-mode 'python-mode
    "mr" (lambda ()
           (interactive)
           (run-python "python3"))
    "me" 'python-shell-send-region))

(use-package emmet-mode
  :straight t
  :diminish emmet-mode
  :hook ((web-mode . emmet-mode))
  :commands (emmet-expand-line)
  :config
  (evil-define-key 'insert web-mode-map (kbd "C-,") 'emmet-expand-line))

(use-package ob-restclient
  :straight t)

(use-package org-bullets
  :straight t
  :hook (org-mode . org-bullets-mode))

(use-package markdown-mode
  :straight t
  :hook (markdown-mode . visual-line-mode))

(use-package yaml-mode
  :straight t)

;; LSP
(use-package lsp-mode
  :straight t
  :preface
  (defun my/web-mode-lsp-trigger ()
    (when (member (file-name-extension (buffer-name)) '("js" "jsx" "ts" "tsx"))
      (lsp)))
  :hook ((web-mode . my/web-mode-lsp-trigger)
         (typescript-mode . lsp)
         (python-mode . lsp)
         (lsp-mode . lsp-enable-which-key-integration))
  :commands lsp
  :config
  (setq lsp-headerline-breadcrumb-enable nil)
  (with-eval-after-load 'evil-maps
    (define-key evil-normal-state-map (kbd "gd") 'lsp-find-definition)
    (define-key evil-normal-state-map (kbd "gr") 'lsp-find-references)
    (evil-leader/set-key
      "rn" 'lsp-rename)))

(use-package lsp-ui
  :straight t
  :config
  (setq-default lsp-ui-doc-position 'at-point
                lsp-ui-peek-enable nil))

(use-package lsp-treemacs
  :straight t)

(use-package helm-lsp
  :straight t
  :config
  (evil-leader/set-key
    "a" 'helm-lsp-code-actions))

(use-package treemacs
  :straight t
  :config
  (evil-leader/set-key
    "tt" 'treemacs))

(use-package treemacs-all-the-icons
  :straight t
  :config (treemacs-load-theme 'all-the-icons))

(use-package treemacs-projectile
  :straight t
  :config
  (evil-leader/set-key
    "tp" 'treemacs-projectile))

(use-package treemacs-evil
  :straight t
  :config
  (evil-define-key 'treemacs treemacs-mode-map (kbd "C-h") 'evil-window-left)
  (evil-define-key 'treemacs treemacs-mode-map (kbd "C-j") 'evil-window-down)
  (evil-define-key 'treemacs treemacs-mode-map (kbd "C-k") 'evil-window-up)
  (evil-define-key 'treemacs treemacs-mode-map (kbd "C-l") 'evil-window-right))

(use-package editorconfig
  :straight t
  :diminish editorconfig-mode
  :config
  (editorconfig-mode 1))

(use-package flycheck
  :straight t
  :diminish flycheck-mode
  :init
  (setq-default flycheck-disabled-checkers '(ruby-rubocop))
  :config
  (global-flycheck-mode +1))

(use-package which-key
  :straight t
  :diminish which-key-mode
  :config
  (which-key-mode +1)
  (setq which-key-idle-delay 0.4
        which-key-idle-secondary-delay 0.4))

(use-package exec-path-from-shell
  :straight t
  :config
  (when (memq window-system '(mac ns x))
    (exec-path-from-shell-initialize))
  (when (daemonp)
    (exec-path-from-shell-initialize)))

(provide 'init)
;;; init.el ends here
