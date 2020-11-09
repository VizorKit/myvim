;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; load-time settings
(setq gc-cons-threshold 500000000)
(setq gc-cons-percentage .8)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; use-package
(package-initialize)
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(when (not (package-installed-p 'use-package))
  (package-refresh-contents)
  (package-install 'use-package))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; windows setup
(when (eq system-type 'windows-nt)
  ;; be sure to set the HOME environment variable and install git bash
  (setq explicit-shell-file-name "C:\\Program Files\\Git\\bin\\bash.exe")
  (setq explicit-bash.exe-args '("--login" "-i"))
  (setq default-directory "~/"))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; basic emacs setup
(setq inhibit-startup-message t)
(setq visible-bell nil)
(setq ring-bell-function 'ignore)
(setq inhibit-splash-screen t)
(electric-pair-local-mode 1)
(electric-pair-mode 1)
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(global-hl-line-mode t)
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))
(global-display-line-numbers-mode)
(setq byte-compile-warnings '(cl-functions))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; basic editor
(global-set-key (kbd "C-z") 'undo) ;; undo
(global-set-key (kbd "C-s") 'save-buffer) ;; save file
(global-set-key (kbd "C-x") 'kill-region) ;; kills marked region. last marked region if none set.
(global-set-key (kbd "C-w") 'write-file) ;; save as
(global-set-key (kbd "C-v") 'yank) ;; paste
(global-set-key (kbd "C-u") 'kill-ring-save) ;; copy (will be translated to C-c)
(global-set-key (kbd "C-q") 'save-buffers-kill-terminal) ;; quit
(global-set-key (kbd "C-r") 'backward-char) ;; r for reverse f for forward
;; prefixes
(global-set-key (kbd "C-b") ctl-x-map) ;; (buffer-mode) = C-b
(keyboard-translate ?\C-c ?\C-u) ;; translates (user-mode) = C-u
(keyboard-translate ?\C-u ?\C-c) ;; translates (copy C-u) = C-c
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; custom functions binding
(global-set-key (kbd "C-c t") 'toggle-frame-split)
(global-set-key (kbd "C-c i") 'delete-between-pair)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; packages
;;; high contrast custom theme
(use-package autothemer
  :ensure t
  :init
  (autothemer-deftheme
   chris-theme "A theme."
   ((((class color) (min-colors #xFFFFFF)))
    (vk-cyan "cyan")
    (vk-black "black")
    (vk-lt-green "light green")
    (vk-yellow "yellow")
    (vk-purple "magenta")
    (vk-white "ghost white")
    (vk-blue "blue")
    (vk-green "green")
    (vk-gray "gray50")
    (vk-red "red")
    (vk-slate "gray17"))
   ((default (:foreground vk-white :background vk-black))
    (font-lock-keyword-face (:foreground vk-yellow :weight 'bold))
    (font-lock-constant-face (:foreground vk-green :weight 'bold))
    (font-lock-comment-face (:foreground vk-cyan))
    (font-lock-string-face (:foreground vk-purple))
    (font-lock-builtin-face (:foreground vk-lt-green :slant 'italic))
    (font-lock-function-name-face (:foreground vk-green :slant 'italic))
    (font-lock-variable-name-face (:foreground vk-lt-green :weight 'bold))
    (error (:foreground vk-red))
     (company-tooltip (:background vk-slate))
    (company-tooltip-common (:weight 'bold :foreground vk-purple))
    (hl-line (:background vk-slate))
    (region (:background vk-blue ))
    (cursor (:background vk-yellow))))
  :config
  (enable-theme 'chris-theme))
;;; company
(use-package company
  :ensure t
  :hook ((after-init . global-company-mode))
  :bind (:map company-active-map
         ("C-n" . company-select-next)
         ("C-p" . company-select-previous))
  :config
  (setq company-idle-delay 0)
  (setq company-minimum-prefix-length 1)
  (setq company-selection-wrap-around t))
;;; which-key
(use-package which-key
  :ensure t
  :config
  (add-hook 'after-init-hook 'which-key-mode))
;;; ivy
(use-package ivy
  :ensure t
  :config
  (global-set-key (kbd "C-b b") 'ivy-switch-buffer)
  (global-set-key (kbd "C-b C-b") 'ivy-switch-buffer-other-window)
  (setq ivy-use-virtual-buffers t
                ivy-count-format "%d/%d ")
  (setq ivy-initial-inputs-alist nil)
  (setq ivy-re-builders-alist
        '((t . ivy--regex-plus))))
;;; counsel
(use-package counsel
  :ensure t
  :config
  (global-set-key (kbd "C-b s") 'swiper-isearch)
  (global-set-key (kbd "C-h f") 'counsel-describe-function)
  (global-set-key (kbd "C-h v") 'counsel-describe-variable)
  (global-set-key (kbd "C-b f") 'counsel-find-file)
  (global-set-key (kbd "C-c p a") 'counsel-ag)
  (global-set-key (kbd "M-x") 'counsel-M-x))
;;; projectile
(use-package projectile
  :ensure t
  :hook ((after-init . projectile-mode))
  :config
  (setq projectile-project-search-path '("~/source/"))
  (setq projectile-completion-system 'ivy)
  (setq projectile-enable-caching t)
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
  (global-set-key (kbd "C-c p R") 'projectile-replace-regex))

;;; neotree
(use-package neotree
  :ensure t
  :config
  (global-set-key (kbd "C-c n") 'neotree-toggle))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ide features
;;; lsp-mode
(use-package lsp-mode
  :ensure t
  :commands lsp
  :hook ((c-mode . lsp)
	 (c++-mode . lsp)
	 (csharp-mode . lsp))
  :init
  (setq lsp-idle-delay .01
                lsp-signature-doc-lines 5)
  (setq lsp-keymap-prefix "C-l")
  :config
  (setq lsp-clients-clangd-args '("-j=4" "-log=error"))
  (add-hook 'after-init-hook 'global-company-mode)
  (lsp-enable-which-key-integration t))
;;; typescript mode
(use-package typescript-mode
  :ensure t
  :hook ((typescript-mode . lsp)
	 (html-mode . lsp))
  :config
  (setq typescript-indent-level 2))
;;; rust mode
(use-package rust-mode
  :hook (rust-mode . lsp)
  :ensure t
  :config
  (add-hook 'rust-mode-hook
            (lambda () (setq indent-tabs-mode nil)))
  (setq rust-format-on-save t))
;;; flycheck rust
(use-package flycheck-rust
  :ensure t
  :hook (flycheck-mode . flycheck-rust-setup))
;;; csharp-mode
(use-package csharp-mode
  :ensure t
  :defer t)
;;; omnisharp
(use-package omnisharp
  :ensure t
  :hook ((csharp-mode . omnisharp-mode)
	 (csharp-mode . (lambda ()
			  (setq indent-tabs-mode nil)
			  (setq c-syntactic-indentation t)
			  (c-set-style "ellemtel")
			  (setq c-basic-offset 4)
			  (setq truncate-lines t))))
  :config
  (eval-after-load 'company '(add-to-list 'company-backends 'company-omnisharp)))
;;; lsp ui
(use-package lsp-ui
  :ensure t
  :hook (lsp-mode . lsp-ui-mode)
  :custom
  (lsp-ui-doc-position 'bottom))
;;; lsp-ivy
(use-package lsp-ivy
  :after ivy
  :defer t
  :ensure t)
;;; flychceck
(use-package flycheck
  :ensure t
  :config
  (define-key flycheck-mode-map flycheck-keymap-prefix nil)
  (setq flycheck-keymap-prefix (kbd "C-l c"))
  (define-key flycheck-mode-map flycheck-keymap-prefix flycheck-command-map)
  (global-flycheck-mode))
;;; org-mode
(use-package org
  :ensure t
  :defer t
  :config
    (global-set-key (kbd "C-c l") 'org-store-link)
    (global-set-key (kbd "C-c a") 'org-agenda)
    (global-set-key (kbd "C-c c") 'org-capture)
    (setq org-log-done t))
;;; tabout!
(use-package tab-jump-out
  :ensure t
  :config
  (define-globalized-minor-mode my-global-tabout-mode tab-jump-out-mode
  (lambda () (tab-jump-out-mode 1)))
  (my-global-tabout-mode))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; custom functions
;;; toggle frame split
(defun toggle-frame-split ()
    "If the frame is split vertically, split it horizontally or vice versa.
Assumes that the frame is only split into two."
    (interactive)
    (unless (= (length (window-list)) 2) (error "Can only toggle a frame split in two"))
    (let ((split-vertically-p (window-combined-p)))
      (delete-window)
      (if split-vertically-p
                  (split-window-horizontally)
                (split-window-vertically))
      (switch-to-buffer nil)))
;;; delete inbetween
(defun seek-backward-to-char (chr)
  "Seek backwards to a character."
  (interactive "cSeek back to char: ")
  (while (not (= (char-after) chr))
    (forward-char -1)))
(setq char-pairs
      '(( ?/  . ?/  )
                ( ?\" . ?\" )
                ( ?\' . ?\' )
                ( ?\( . ?\) )
                ( ?\[ . ?\] )
                ( ?\{ . ?\} )
                ( ?<  . ?>  )))
(defun get-char-pair (chr)
  (let ((result ()))
    (dolist (x char-pairs)
      (setq start (car x))
      (setq end (cdr x))
      (when (or (= chr start) (= chr end))
                (setq result x)))
    result))
(defun get-start-char (chr)
  (car (get-char-pair chr)))
(defun get-end-char (chr)
  (cdr (get-char-pair chr)))
(defun seek-to-matching-char (start end count)
  (while (> count 0)
    (if (= (following-char) end)
                (setq count (- count 1))
      (if (= (following-char) start)
                  (setq count (+ count 1))))
    (forward-char 1)))
(defun seek-backward-to-matching-char (start end count)
  (if (= (following-char) end)
      (forward-char -1))
  (while (> count 0)
    (if (= (following-char) start)
                (setq count (- count 1))
      (if (= (following-char) end)
                  (setq count (+ count 1))))
    (if (> count 0)
                (forward-char -1))))
(defun delete-between-pair (char)
  "Delete in between the given pair"
  (interactive "cDelete between char: ")
  (seek-backward-to-matching-char (get-start-char char) (get-end-char char) 1)
  (forward-char 1)
  (setq mark (point))
  (seek-to-matching-char (get-start-char char) (get-end-char char) 1)
  (forward-char -1)
  (kill-region mark (point)))
(defun delete-all-pair (char)
  "Delete in between the given pair and the characters"
  (interactive "cDelete all char: ")
  (seek-backward-to-matching-char (get-start-char char) (get-end-char char) 1)
  (setq mark (point))
  (forward-char 1)
  (seek-to-matching-char (get-start-char char) (get-end-char char) 1)
  (kill-region mark (point)))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; profiling & normal gc settings
(setq gc-cons-threshold 800000)
(setq gc-cons-percentage .2)
(add-hook 'emacs-startup-hook
          (lambda ()
            (message "Emacs ready in %s with %d garbage collections."
                     (format "%.2f seconds"
                             (float-time
                              (time-subtract after-init-time before-init-time)))
                     gcs-done)))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; end for custom-set variables
