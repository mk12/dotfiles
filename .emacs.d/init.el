;; ========== Optimizations ====================================================

;; Disable garbage collection and the file name handler during startup.
(setq default-gc-cons-threshold gc-cons-threshold
      default-file-name-handler-alist file-name-handler-alist
      gc-cons-threshold (* 64 1024 1024)
      file-name-handler-alist nil)
(add-hook 'after-init-hook
          (lambda ()
            (setq gc-cons-threshold default-gc-cons-threshold
                  file-name-handler-alist default-file-name-handler-alist)))

;; ========== Packages =========================================================

(defun config-path (rel)
  "Get a path relative to the user Emacs directory (usually ~/.emacs.d)."
  (expand-file-name rel user-emacs-directory))

(defconst bootstrap-url
  "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el")
(defvar bootstrap-version)
(let ((bootstrap-file (config-path "straight/repos/straight.el/bootstrap.el"))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously bootstrap-url 'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(setq straight-vc-git-default-clone-depth 1)

(straight-use-package 'base16-theme)
(straight-use-package 'column-marker)
(straight-use-package 'counsel)
(straight-use-package 'diminish)
(straight-use-package 'doom-modeline)
(straight-use-package 'dtrt-indent)
(straight-use-package 'expand-region)
(straight-use-package 'fill-column-indicator)
(straight-use-package 'lispy)
(straight-use-package 'magit)
(straight-use-package 'move-text)
(straight-use-package 'projectile)

;; ========== Options ==========================================================

(setq-default fill-column 80
              indent-tabs-mode nil
              tab-width 4
              truncate-lines t
              word-wrap t)

(setq ad-redefinition-action 'accept
      apropos-do-all t
      blink-matching-paren t
      delete-by-moving-to-trash (eq system-type 'darwin)
      dired-recursive-copies 'always
      dired-recursive-deletes 'always
      doom-modeline-icon nil
      doom-modeline-project-detection 'projectile
      fci-rule-character ?│
      fci-rule-character-color "brightyellow"
      find-file-suppress-same-file-warnings t
      find-file-visit-truename t
      kill-do-not-save-duplicates t
      message-log-max 8192
      projectile-completion-system 'ivy
      require-final-newline t
      ring-bell-function 'ignore
      sentence-end-double-space nil
      truncate-partial-width-windows nil
      vc-follow-symlinks t)

;; Start up with an empty scratch buffer.
(setq inhibit-startup-screen t
      inhibit-startup-echo-area-message user-login-name
      inhibit-default-init t
      initial-major-mode 'fundamental-mode
      initial-scratch-message nil)

;; Ensure UTF-8 is the default.
(when (fboundp 'set-charset-priority)
  (set-charset-priority 'unicode))
(prefer-coding-system 'utf-8)
(setq locale-coding-system 'utf-8)
(setq selection-coding-system 'utf-8)

;; Don't clutter the working directory.
(let ((autosave-dir (config-path "autosave/"))
      (backup-dir (config-path "backup/")))
  (make-directory autosave-dir :parents)
  (make-directory backup-dir :parents)
  (setq auto-save-file-name-transforms `((".*" ,autosave-dir t))
        backup-directory-alist `(("." . ,backup-dir))
        save-place-file (config-path "places")
        create-lockfiles nil))

;; Make tabify/untabify only affect leading indentation.
(setq tabify-regexp "^\t* [ \t]+")

;; Optimizations copied from Doom.
(setq-default bidi-display-reordering 'left-to-right
              bidi-paragraph-direction 'left-to-right
              cursor-in-non-selected-windows nil)
(setq auto-mode-case-fold nil
      fast-but-imprecise-scrolling t
      ffap-machine-p-known 'reject
      frame-inhibit-implied-resize t
      gcmh-high-cons-threshold (* 16 1024 1024)
      gcmh-idle-delay 5
      highlight-nonselected-windows nil
      idle-update-delay 1.0
      inhibit-compacting-font-caches t)

;; ========== Modes ============================================================

(require 'diminish)
(require 'mwheel)

(counsel-mode 1)
(delete-selection-mode 1)
(doom-modeline-mode 1)
(global-auto-revert-mode 1)
(global-hl-line-mode 1)
(ivy-mode 1)
(midnight-mode 1)
(mouse-wheel-mode)
(projectile-mode 1)
(save-place-mode 1)
(xterm-mouse-mode 1)

(menu-bar-mode -1)

(add-hook 'text-mode-hook
          (lambda ()
            (visual-line-mode 1)))

(add-hook 'prog-mode-hook
          (lambda ()
            (display-line-numbers-mode 1)
            (dtrt-indent-mode 1)
            (fci-mode 1)))

(add-hook 'lisp-mode-hook
          (lambda ()
            (lispy-mode 1)))

(diminish 'counsel-mode)
(diminish 'ivy-mode)
(diminish 'projectile-mode)

;; ========== Color scheme =====================================================

(load-theme 'base16-default-dark t)

;; Don't use a darker background for the active modeline. They are already
;; distinct enough thanks to doom-modeline.
(set-face-attribute 'mode-line nil :background "brightgreen")

;; Make line numbers more subtle.
(set-face-attribute 'line-number nil
                    :foreground "brightblack" :background "brightgreen")
(set-face-attribute 'line-number-current-line nil
                    ;; These are inverted for some reason.
                    :foreground "brightgreen" :background "brightblue" :bold t)

;; Use a solid block for the vertical split instead of pipe characters.
(set-face-attribute 'vertical-border nil
                    :foreground "brightyellow" :background "brightyellow")

(with-eval-after-load 'magit
  ;; magit-section.el
  (set-face-background 'magit-section-highlight "brightgreen")
  (set-face-foreground 'magit-section-heading "yellow")
  (set-face-foreground 'magit-section-heading-selection "yellow")
  ;; magit-blame.el
  (set-face-foreground 'magit-blame-highlight "magenta")
  (set-face-background 'magit-blame-highlight "default")
  ;; magit-diff.el
  (set-face-foreground 'magit-diff-file-heading-selection "default")
  (set-face-foreground 'magit-diff-hunk-heading "default")
  (set-face-foreground 'magit-diff-hunk-heading-highlight "default")
  (set-face-background 'magit-diff-hunk-heading-highlight "brightgreen")
  (set-face-foreground 'magit-diff-hunk-heading-selection "default")
  (set-face-foreground 'magit-diff-lines-heading "blue")
  (set-face-background 'magit-diff-lines-heading "default")
  (set-face-foreground 'magit-diff-added "green")
  (set-face-background 'magit-diff-added "default")
  (set-face-foreground 'magit-diff-removed "red")
  (set-face-background 'magit-diff-removed "default")

  (set-face-foreground 'magit-diff-our "default")
  (set-face-background 'magit-diff-our "default")
  (set-face-foreground 'magit-diff-base "default")
  (set-face-background 'magit-diff-base "default")
  (set-face-foreground 'magit-diff-their "default")
  (set-face-background 'magit-diff-their "default")

  (set-face-foreground 'magit-diff-context "default")

  (set-face-foreground 'magit-diff-added-highlight "green")
  (set-face-background 'magit-diff-added-highlight "brightgreen")
  (set-face-foreground 'magit-diff-removed-highlight "red")
  (set-face-background 'magit-diff-removed-highlight "brightgreen")

  (set-face-foreground 'magit-diff-our-highlight "default")
  (set-face-background 'magit-diff-our-highlight "brightgreen")
  (set-face-foreground 'magit-diff-base-highlight "default")
  (set-face-background 'magit-diff-base-highlight "brightgreen")
  (set-face-foreground 'magit-diff-their-highlight "default")
  (set-face-background 'magit-diff-their-highlight "brightgreen")

  (set-face-foreground 'magit-diff-context-highlight "default")
  (set-face-background 'magit-diff-context-highlight "brightgreen")

  (set-face-foreground 'magit-diffstat-added "green")
  (set-face-foreground 'magit-diffstat-removed "red")

  ;; magit-sequence.el
  ;; magit.el
  ;; magit-bisect.el
  ;; magit-process.el
  ;; magit-log.el
  ;; magit-reflog.el
  )

;; ========== Keybindings ======================================================

(global-set-key (kbd "C-x C-r") 'reload-init-file)

(global-set-key (kbd "C-x C-y") 'system-copy)

;; Fix Cmd-Left and Cmd-Right.
(global-set-key (kbd "M-[ H") 'move-beginning-of-line)
(global-set-key (kbd "M-[ F") 'move-end-of-line)

(global-set-key (kbd "<M-delete>") 'kill-word)

;; <M-up> and <M-down> to move lines.
(move-text-default-bindings)

(global-set-key (kbd "<M-S-up>") 'duplicate-up)
(global-set-key (kbd "<M-S-down>") 'duplicate-down)

(global-set-key (kbd "C-r") 'er/expand-region)

(global-set-key (kbd "C-s") 'swiper)

(global-set-key (kbd "C-x g") 'magit-status)
(global-set-key (kbd "C-x p") 'projectile-command-map)

;; For C-x C-j (dired-jump).
(require 'dired-x)

;; ========== Commands =========================================================

;; Enable commands that new users find confusing.
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)
(put 'erase-buffer 'disabled nil)

(defun reload-init-file ()
  "Reload Emacs configuration file."
  (interactive)
  (load-file user-init-file))

(defun system-copy (start end)
  "Copy to the system clipboard using yank from mk12/scripts."
  (interactive "r")
  (write-region
   (with-output-to-string
     (call-process-region start end "yank" nil standard-output))
   nil
   (terminal-name)
   t
   0))

(defun duplicate-up ()
  "Duplicate the current line or region up."
  (interactive "*")
  (duplicate-line-or-region -1))

(defun duplicate-down ()
  "Duplicate the current line or region down."
  (interactive "*")
  (duplicate-line-or-region 0))

;; ========== Functions ========================================================

(defun duplicate-line-or-region (dir)
  (let ((use-region (use-region-p)))
    (save-excursion
      (cond
        (use-region
          (expand-selection-whole-lines)
          (insert (buffer-substring (region-beginning) (region-end))))
        (t (beginning-of-line)
           (insert (thing-at-point 'line)))))
    ;; When duplicating a line, return to the same column.
    (unless use-region 
      (let ((pos (- (point) (line-beginning-position))))
        (forward-line (+ dir (if (zerop pos) 1 0)))
        (forward-char pos)))))

(defun expand-selection-whole-lines ()
  (let ((start (region-beginning))
        (end (region-end)))
    (goto-char start)
    (beginning-of-line)
    (setq start (point))
    (goto-char end)
    (unless (or (= 0 (current-column))
                (progn (forward-line) (= 0 (current-column))))
      (newline))
    (setq end (point))
    (setq deactivate-mark nil)
    (set-mark start)))
