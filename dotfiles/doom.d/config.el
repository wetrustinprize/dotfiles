;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Peterson \"Prize\" Adami Candido"
      user-mail-address "contact.petersonac@protonmail.com")

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
(setq doom-theme 'doom-nord
      doom-font (font-spec :family "JetBrainsMono Nerd Font" :size 16)
      doom-unicode-font (font-spec :family "JetBrainsMono Nerd Font"))

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; Word wrap
(add-hook! 'prog-mode-hook 'visual-line-mode)

;; Github Copilot package and configuration
(use-package! copilot
  :hook (prog-mode . copilot-mode)
  :bind (("C-TAB" . 'copilot-accept-completion-by-word)
         ("C-<tab>" . 'copilot-accept-completion-by-word)
         :map copilot-completion-map
         ("<tab>" . 'copilot-accept-completion)
         ("TAB" . 'copilot-accept-completion)))

(setq copilot-node-executable "/usr/local/n/versions/node/17.8.0/bin/node")

;; Tide configuration
(use-package! tide
  :after (typescript-mode company flycheck)
  :hook ((typescript-mode . tide-setup)
         (typescript-mode . tide-hl-identifier-mode))
  :config
  (setq tide-completion-detailed t
        tide-always-show-documentation t)
  :bind (:map tide-mode-map
              ("C-c f" . tide-fix)
              ("C-c r" . tide-rename-symbol)
              ("C-c R" . tide-rename-file)
              ("C-c t" . tide-references)
              ("C-c i" . tide-organize-imports)))

;; LSP optimization
(setq gc-cons-threshold 100000000)
(setq read-process-output-max (* 1024 1024)) ;; 1mb
(setq lsp-file-watch-threshold 10000)

;; Don't create new workspace everytime a emacsclient is opened
(after! persp-mode
  (setq persp-emacsclient-init-frame-behaviour-override "main"))
