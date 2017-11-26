;;; Preamble

(require 'package)
(setq package-enable-at-startup nil)
(setq package-archives
      '(("org"       . "http://orgmode.org/elpa/")
        ("gnu"       . "http://elpa.gnu.org/packages/")
        ("melpa"     . "https://melpa.org/packages/")
        ("marmalade" . "http://marmalade-repo.org/packages/")))
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(setq use-package-always-ensure t)
(require 'use-package)

;;; Custom file

(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(unless (file-exists-p custom-file)
  (write-region "" nil custom-file))
(load custom-file)

;;; Packages

(use-package better-defaults)
(use-package exec-path-from-shell)
(use-package org)
(use-package solarized-theme)

(setq shell-file-name "/usr/local/bin/fish") ; necessary?
(exec-path-from-shell-initialize)

;;; Theme and font

(load-theme 'solarized-light)

;;; General options

(setq default-fill-column 80)
(setq org-confirm-babel-evaluate nil)
(setq org-src-fontify-natively t)
(setq sentence-end-double-space nil)
(setq org-image-actual-width (list (/ (window-pixel-width) 2)))
;(setq org-latex-create-formula-image-program 'dvisvgm)
