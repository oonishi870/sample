
(package-initialize)
;;(add-to-list 'face-font-rescale-alist '(".*TakaoP.*" . 0.85)) ; Wrong



(setq package-archives
      '(("gnu" . "http://elpa.gnu.org/packages/")
        ("melpa" . "http://melpa.org/packages/")
        ("org" . "http://orgmode.org/elpa/")))




(scroll-bar-mode -1)

;; 2018/05/11 oonishi
(setq load-path (cons "~/.emacs.d/mylisp" load-path))

;; カスタムテーマフォルダを設定 2018/04/05 oonishi
;; https://github.com/emacs-jp/replace-colorthemes/blob/master/screenshots.md
;;(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")
;;(setq custom-theme-directory "~/.emacs.d/themes")
(deftheme my-theme
  "Created 2018-05-23.")


;; 2020/08/23 emacs27では以下がないとテーマが反映されない
(setq custom--inhibit-theme-enable nil)

(custom-theme-set-variables
 'my-theme
 '(ansi-color-names-vector ["#242424" "#e5786d" "#D0A0A0" "#cae682" "#A0FFD0" "#333366" "#ccaa8f" "#f6f3e8"]))

(custom-theme-set-faces
 'my-theme
 '(cursor ((((class color) (min-colors 89)) (:background "#656565"))))
 '(fringe ((((class color) (min-colors 89)) (:background "#303030"))))
 '(highlight ((((class color) (min-colors 89)) (:background "#454545" :foreground "#ffffff" :underline t))))
 '(region ((((class color) (min-colors 89)) (:background "#80A0A0" :foreground "#FFFFFF"))))
 '(secondary-selection ((((class color) (min-colors 89)) (:background "#333366" :foreground "#f6f3e8"))))
 '(isearch ((t (:background "white" :foreground "brightcyan"))))
 '(lazy-highlight ((((class color) (min-colors 89)) (:background "#384048" :foreground "#a0a8b0"))))
 '(mode-line ((((class color) (min-colors 89)) (:background "#444444" :foreground "#f6f3e8"))))
 '(mode-line-inactive ((((class color) (min-colors 89)) (:background "#444444" :foreground "#857b6f"))))
 '(minibuffer-prompt ((t (:foreground "#80D0FF"))))
 '(escape-glyph ((t (:foreground "color-43" :weight bold))))
 '(font-lock-builtin-face ((t (:foreground "#A0D0FF"))))
 '(font-lock-comment-face ((((class color) (min-colors 89)) (:foreground "#99968b"))))
 '(font-lock-constant-face ((t nil)))
 '(font-lock-function-name-face ((t nil)))
 '(font-lock-keyword-face ((t (:foreground "#C0C0FF" :weight bold))))
 '(font-lock-string-face ((t (:foreground "#B0FFB0"))))
 '(font-lock-type-face ((t (:weight bold))))
 '(font-lock-variable-name-face ((t nil)))
 '(font-lock-warning-face ((((class color) (min-colors 89)) (:foreground "#ccaa8f"))))
 '(link ((((class color) (min-colors 89)) (:foreground "#A0FFD0" :underline t))))
 '(link-visited ((((class color) (min-colors 89)) (:foreground "#e5786d" :underline t))))
 '(button ((((class color) (min-colors 89)) (:background "#333333" :foreground "#f6f3e8"))))
 '(header-line ((((class color) (min-colors 89)) (:background "#303030" :foreground "#e7f6da"))))
 '(default ((((class color) (min-colors 89)) (:background "#242424" :foreground "#f6f3e8")))))


;; emacs27にバージョンが上がったら選択色がわかりにくくなった
(set-face-background 'region "DeepSkyBlue")


;; (load-theme 'wombat nil)
;;(load-theme 'whiteboard t)      ;; テーマwombat
;;(load-theme 'wombat t)      ;; テーマwombat
;;(load-theme 'my-theme t)      ;; 自作テーマ
(set 'py-split-windows-on-execute-function 'split-window-horizontally) ;; 分割を左右にする


(setq x-select-enable-clipboard t)


;; kill-ringではなく、クリップボードを使う
;; クリップボードにコピー
;; If emacs is run in a terminal, the clipboard- functions have no
;; effect. Instead, we use of xsel, see
;; http://www.vergenet.net/~conrad/software/xsel/ -- "a command-line
;; program for getting and setting the contents of the X selection"
(unless window-system
 (when (getenv "DISPLAY")
  ;; Callback for when user cuts
  (defun xsel-cut-function (text &optional push)
    ;; Insert text to temp-buffer, and "send" content to xsel stdin
    (with-temp-buffer
      (insert text)
      ;; I prefer using the "clipboard" selection (the one the
      ;; typically is used by c-c/c-v) before the primary selection
      ;; (that uses mouse-select/middle-button-click)
      (call-process-region (point-min) (point-max) "xsel" nil 0 nil "--clipboard" "--input")))
  ;; Call back for when user pastes
  (defun xsel-paste-function()
    ;; Find out what is current selection by xsel. If it is different
    ;; from the top of the kill-ring (car kill-ring), then return
    ;; it. Else, nil is returned, so whtatever is in the top of the
    ;; kill-ring will be used.

    
    ;; (let ((tramp-mode nil))
    ;; (let ((xsel-output (shell-command-to-string "xsel --clipboard --output")))
    ;;   (unless (string= (car kill-ring) xsel-output)
    ;; 	xsel-output ))))
    
    ;; (let ((xsel-output (shell-command-to-string "xsel --clipboard --output")))
    ;;   (unless (string= (car kill-ring) xsel-output)
    ;; 	xsel-output )))

    (let ((tramp-mode nil) (default-directory "~")) ;; これがないとtrampモードでxselがリモート側になる
    (let ((xsel-output (shell-command-to-string "xsel --clipboard --output")))
      ;;(message xsel-output)
      (unless (string= (car kill-ring) xsel-output)
	xsel-output )))
    )
  
  ;; Attach callbacks to hooks
  (setq interprogram-cut-function 'xsel-cut-function)
  (setq interprogram-paste-function 'xsel-paste-function)
  ;; Idea from
  ;; http://shreevatsa.wordpress.com/2006/10/22/emacs-copypaste-and-x/
  ;; http://www.mail-archive.com/help-gnu-emacs@gnu.org/msg03577.html
  ))


;; 2019-07-07 oonishi comment out
;; ;; 行番号 2018/04/03 oonishit
;; ;; https://teratail.com/questions/63975
;; (global-linum-mode t)
;; (setq linum-format "%4d| ")
;; (set-face-attribute 'linum nil
;;            :foreground "#a9a9a9"
;;            :background "#404040"
;;            :height 0.9)
;; (setq linum-delay t)
;; (defadvice linum-schedule (around my-linum-schedule () activate)
;;  (run-with-idle-timer 0.2 nil #'linum-update-current))
;;

;;(global-nlinum-mode t)

;; (unless window-system
;; (setq nlinum-format "%4d| "))
;; (set-face-attribute 'linum nil
;;             :foreground "#a9a9a9"
;; ;;            :background "#404040"
;;             :height 0.9)

;; (add-hook 'eshell-mode-hook
;;    (function
;;     (lambda ()
;;       ;;; シェルバッファの行数の上限を3000行にする
;;       (setq comint-buffer-maximum-size 3000)
;;       ;;(setq comint-output-filter-functions
;;       ;;    'comint-truncate-buffer)
;;       (setq nlinum-mode nil)
;;       )))


(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (foundry "Ubuntu Mono" :family "Myrica M" :foundry "ES" :slant normal :weight normal :height 113 :width normal))))
 '(fringe ((t (:background "gray30")))))


;; shellモードとかでは行番号off 2018/04/03 oonishi
;; https://lists.gnu.org/archive/html/help-gnu-emacs/2013-09/msg00176.html
(global-display-line-numbers-mode)
(add-hook 'shell-mode-hook '(lambda () (display-line-numbers-mode -1)))
(add-hook 'compilation-mode-hook '(lambda () (display-line-numbers-mode -1)))
(add-hook 'interpretation-mode-hook '(lambda () (display-line-numbers-mode -1)))


;; (add-hook 'shell-mode-hook '(lambda () (linum-mode -1)))
;; (add-hook 'compilation-mode-hook '(lambda () (linum-mode -1)))
;; (add-hook 'interpretation-mode-hook '(lambda () (linum-mode -1)))
;; (add-hook 'markdown-mode-hook '(lambda () (linum-mode -1)))

;; (add-hook 'shell-mode-hook '(lambda () (nlinum-mode -1)))
;; (add-hook 'compilation-mode-hook '(lambda () (nlinum-mode -1)))
;; (add-hook 'interpretation-mode-hook '(lambda () (nlinum-mode -1)))
;; (add-hook 'org-mode-hook '(lambda () (nlinum-mode -1)))

;; マウス設定 2018/04/04 oonishi
(xterm-mouse-mode t)
(mouse-wheel-mode t)
(global-set-key [mouse-4] '(lambda () (interactive) (scroll-down 3)))
(global-set-key [mouse-5] '(lambda () (interactive) (scroll-up   3)))

;;(modify-syntax-entry ?_ "w" c++-mode-syntax-table)


;; なくてもいいかも？ 2018/05/07 oonishi
(require 'expand-region)
;;(er/expand-region-skip-whitespace f)
;; 真っ先に入れておかないとすぐに括弧に対応してくれない…
(push 'er/mark-outside-pairs er/try-expand-list)

(global-hl-line-mode t)                   ;; 現在行をハイライト
(show-paren-mode t)                       ;; 対応する括弧をハイライト
(setq show-paren-style 'mixed)            ;; 括弧のハイライトの設定。
(transient-mark-mode t)                   ;; 選択範囲をハイライト
(set-face-underline-p 'highlight nil)     ;; 現在行のハイライトは色だけでいい

;;
;; volatile-highlights
;;
(require 'volatile-highlights)
(volatile-highlights-mode t)

;; ;;(global-hl-line-mode t)                   ;; 現在行をハイライト
;; (show-paren-mode t)                       ;; 対応する括弧をハイライト
;; (setq show-paren-style 'mixed)            ;; 括弧のハイライトの設定。
;; (transient-mark-mode t)                   ;; 選択範囲をハイライト

;; ;;(setq hl-line-face 'color)

;; ;;;; 現在行を目立たせる
;; ;;(setq hl-line-face 'underline)
;; (global-hl-line-mode)


;; yasnippet 2018/04/12 oonisih
(yas-global-mode 1)

;; homeキーをNotepad++ライクに変更
;;(defun back-to-indentation-or-beginning () (interactive)
;;   (if (= (point) (progn (back-to-indentation) (point)))
;;       (beginning-of-line)))
(defun back-to-indentation-or-beginning ()
    (interactive)
    (if this-command-keys-shift-translated
        (unless mark-active (push-mark nil t t))
      (when (and mark-active cua--last-region-shifted)
        (deactivate-mark)))
    (if (= (point) (progn (back-to-indentation) (point)))
        (beginning-of-line)))
(define-key global-map (kbd "<home>") 'back-to-indentation-or-beginning)
;;(define-key global-map (kbd "S-<home>")  'hello-world)

;; C-x C-c C-vがwindowsライクになる 2018/04/12 oonishi
;;(require 'cua)
(cua-mode t)



;; _が単語区切りとなるのを避ける 2018/04/03 oonishi
(require 'python)
(require 'cc-mode)
;;(require 'sh-mode)


;(modify-syntax-entry ?_ "w")
(modify-syntax-entry ?_ "w" python-mode-syntax-table)
(modify-syntax-entry ?_ "w" shell-mode-syntax-table)
;;(modify-syntax-entry ?_ "w" sh-mode-syntax-table)
;;(modify-syntax-entry ?_ "w" markdown-mode-syntax-table)
(modify-syntax-entry ?_ "w" c-mode-syntax-table)
(modify-syntax-entry ?_ "w" c++-mode-syntax-table)


;; 2019/07/26 自作
(require 'helm)
(require 'helm-swoop)
;;(defun my/search()
(defun my/swiper()
  (interactive)
  (if (region-active-p)
      ;; (helm-swoop :$query (buffer-substring (region-beginning) (region-end)))
      ;; 	  (helm-swoop :$query "")
      (let (
	    (s (buffer-substring (region-beginning) (region-end)))
	    )
        (set-mark nil)
	(swiper s))
      (swiper)
))
;;(provide 'my/search)
(provide 'my/swiper)



;; キーバインド用マイナーモード
;; http://d.hatena.ne.jp/rubikitch/20101126/keymap
;; (makunbound 'overriding-minor-mode-map)

(define-minor-mode overriding-minor-mode
  "強制的にC-tを割り当てる"             ;説明文字列
  t                                     ;デフォルトで有効にする
  ""                                    ;モードラインに表示しない
  `(
	;;(,(kbd "C-t") . other-window-or-sprit)
    ;; (, (kbd "C-b") . nil) ;; 2018/06/27 tmux用
    ;; (, (kbd "C-z") . redo)
    ;; (, (kbd "C-y") . redo)
    ;; ;;(, (kbd "C-f") . isearch-forward)
    ;; (, (kbd "C-f") . my/swiper)
    ;; (, (kbd "C-r") . isearch-backward)
    ;; (, (kbd "C-s") . save-buffer)
    ;; (, (kbd "C-t") . (lambda (&optional arg) (interactive "P") (if (null arg) (other-window 1) (other-window -1))))	
    ;; (, (kbd "C-h") . er/expand-region)

	
    ;; (, (kbd "C-k") . nil)
    ;; (, (kbd "C-k C-n") . helm-mini)
    ;; (, (kbd "C-k C-f") . helm-find-files)
    ;; (, (kbd "C-k C-l") . helm-M-x)
    ;; (, (kbd "C-k C-w") . kill-buffer)
    ;; (, (kbd "C-k C-k") . comment-dwim)
    ;; (, (kbd "C-k C-j") . goto-line)
    ;; ;;(, (kbd "C-k C-o") . switch-to-prev-buffer)
    ;; ;;(, (kbd "C-k C-p") . switch-to-next-buffer)
    ;; (, (kbd "C-k C-h") . swap-buffers)
    ;; ;;(, (kbd "C-k C-u") . helm-swoop)
    ;; (, (kbd "C-k C-u") . my/swiper)
    ;; (, (kbd "C-k C-t") . my/turn-buffer)
	))

(setq my/mdcoderun--last-command "")

;; tramp-modeでのファイル名から"/scp:user@192.168.x.x:" 部分を削除する

(defun my/buffer-file-name ()
  (if (tramp-tramp-file-p (buffer-file-name))
      (tramp-file-name-localname (tramp-dissect-file-name (buffer-file-name)))
    (buffer-file-name)))

;; 2020/02/12 mdcoderunの改修にあわせてMDCODERUN_LANG2EXEC を設定した
;; 2019/11/04 markdownのコードブロックを実行
(defun my/mdcoderun()
  (interactive)
  (if (buffer-file-name)
      (let(
		   (process-environment (append  
								 process-environment '("MDCODERUN_LANG2EXEC=elisp=emacsclient -e '(load \"{}\")',emacs-lisp=emacsclient -e '(load \"{}\")'")))
								 ;;process-environment '("MDCODERUN_LANG2EXEC=elisp=cat {},")))  
           (lno (line-number-at-pos (point))))
        (save-buffer)
        ;; 2020/08/04 再実行対応
        ;;(executable-interpret (format "mdcoderun %s --keep-lineno -l %d --run|cat" (buffer-file-name) lno)))
        (executable-interpret 
	   (setq my/mdcoderun--last-command 
		 ;;(format "mdcoderun %s --keep-lineno -l %d --run|cat" (buffer-file-name) lno))))
		 (format "mdcoderun %s --keep-lineno -l %d --run|cat" (my/buffer-file-name) lno))))

      (let* (
		   (process-environment (append  
								 process-environment '("MDCODERUN_LANG2EXEC=elisp=emacsclient -e '(load \"{}\")',emacs-lisp=emacsclient -e '(load \"{}\")'")))
	   (process-connection-type nil)
           (lno (line-number-at-pos (point)))
           (buf  (executable-interpret (format "mdcoderun --keep-lineno -l %d --run|cat" lno)))
           (proc (get-buffer-process buf)))

      ;;(process-send-string proc "test\n")
      ;;(process-send-region proc (point-min) (point-max))
      (process-send-string proc (substring-no-properties (buffer-string) 0))
      (process-send-string proc "\n")
      (process-send-eof proc)
      ;;(or (get-buffer "*interpretation*") (generate-new-buffer "*interpretation*"))
      ))
 )

(provide 'my/mdcoderun)

(defun my/mdcoderun-again(&optional arg)
  (interactive "P")
  (executable-interpret my/mdcoderun--last-command)
)

(provide 'my/mdcoderun-again)


;; 2020/03/03 undo-treeがpolymode-markdownと相性がいい
(require 'undo-tree)
(global-undo-tree-mode t)

(bind-keys :map overriding-minor-mode-map
    ;;("C-b" . nil) ;; 2018/06/27 tmux用
    ( "C-z" . undo-tree-undo)
    ( "C-y" . undo-tree-redo)
    ;;( "C-f") . isearch-forward)
    ( "C-b" . isearch-forward)
    ( "C-r" . isearch-backward)
    ( "C-f" . my/search)
    ( "C-s" . save-buffer)
    ( "C-t" . (lambda (&optional arg) (interactive "P") (if (null arg) (other-window  1) (other-window -1))))	
    ;;( "C-r" . (lambda (&optional arg) (interactive "P") (if (null arg) (other-window -1) (other-window  1))))	
    ( "C-h" . er/expand-region)
    
    ( "C-k" . nil)
    ( "C-k C-n" . helm-mini)
    ( "C-k C-f" . helm-find-files)
    ( "C-k C-l" . helm-M-x)
    ( "C-k C-w" . kill-buffer)
    ( "C-k C-k" . comment-dwim)
    ;;( "C-k C-i" . comment-dwim)
    ;;( "C-k C-k" . my/mdcoderun-again)

    ( "C-k C-j" . goto-line)
    ;;( "C-k C-o") . switch-to-prev-buffer)
    ;;( "C-k C-p") . switch-to-next-buffer)
    ;;( "C-k C-h") . swap-buffers)
    ;;( "C-k C-u") . helm-swoop)
    ( "C-k C-u" . my/swiper)
    ( "C-k C-o" . helm-show-kill-ring)
    ( "C-k C-t" . my/turn-buffer)
)

(bind-keys :map isearch-mode-map
	   ("C-b" . isearch-repeat-forward)
	   ("C-f" . isearch-repeat-forward)
	   ("C-r" . isearch-repeat-backward)
	   ;;("C-b" . isearch-repeat-backward)
	   ;; ("C-f" . isearch-forward)
	   ;; ("C-b" . isearch-backward)
	   ;;("<RET>" . isearch-repeat-forward)
	   ;;("s-<RET>" . isearch-repeat-backward)
	   ;;("<ESC>" . isearch-exit)
	   ;;("<ESC>" . nil)
	   ;;("<END>" . isearch-exit)
	   ("<END>" . (lambda ()(
				 (interactive)
				 (isearch-exit)
				 (end-of-line))))
	   
	   ("<HOME>" . (lambda ()(
				 (interactive)
				 (isearch-exit)
				 (beginning-of-line))))
	   ("C-v" . isearch-edit-string)
	   ;;("<RET>" . isearch-exit)
	   )

(bind-keys :map shell-mode-map
	   ("M-<right>" . comint-previous-matching-input-from-input)
	   ("M-<left>" . comint-next-matching-input-from-input)
	   )





;;(require 'redo+)

(savehist-mode 1)

;; Japanese font
;; (set-fontset-font t 'japanese-jisx0208 (font-spec :family "IPAExGothic"))


(require 'helm-swoop)
;;(require 'helm-config)
;;(require 'helm-files)
;;(require 'helm-ag)


;; カレントを隣のバッファに移動する 2018/06/08 oonishi
;; 作ったものの、swap-buffer switch-to-prev-bufferの
;; 組み合わせで足りるので使わない
;; (defun my/turn-buffer ()
;;   (interactive)
;;   ;;(let (buf)()(
;; 	     (setq buf (buffer-name))
;; 	     (switch-to-prev-buffer)
;; 	     (other-window 1)
;; 	     (switch-to-buffer buf)
;; 	     (other-window -1)
;; 	     ;;))
;;   (message (buffer-name))
;;   )

;; 2020/02/17 修正
(defun my/next--window()
  ;;(interactive)
  (let (win)
	(setq win (next-window))
	;;(while (or (window-minibuffer-p win) (< (window-height win)  20) (not (eq win (selected-window))))
	(while (or (window-minibuffer-p win) (< (window-height win)  20) )
	  (setq win (next-window win)))
	(if (eq win (selected-window))
		nil win))
)
(defun my/turn-buffer ()
  (interactive)
  (let (nextwin)
	(setq nextwin (my/next--window))
	(when nextwin
		(set-window-buffer nextwin (current-buffer))
		(switch-to-prev-buffer)
	  ))
)

(provide 'my/turn-buffer)

;;(require 'markdown-mode)
;; (require 'mmm-mode)
;; (setq mmm-global-mode 'maybe)

;; (require 'dash)
;; ;; (require 'mmm-mode)
;; (with-eval-after-load "mmm-mode"
;;   (-each '("sh" "python" "lisp" "org") ;; 引数にメジャーモードの関数 -mode を抜いた文字列のリストを渡す
;;     '(lambda (mode-name)
;;        (let ((md-class (intern (concat "markdown-" mode-name))))
;;          (mmm-add-classes
;;           (list (list md-class
;;                       :submode (intern (concat mode-name "-mode"))
;;                       :face 'mmm-declaration-submode-face
;;                       :front (concat "^```" mode-name "[\n
;; ]+")
;;                       :back "^```$")))
;;          (mmm-add-mode-ext-class 'markdown-mode nil md-class)))))

;; markdown用 2019/03/31

(require 'poly-markdown)
(set-face-attribute 'markdown-code-face nil :inherit 'default)
(set-face-attribute 'markdown-blockquote-face nil :inherit 'default)


;; (define-innermode my/poly-python-innermode
;;   :mode 'python-mode
;;   :head-matcher "'```python\n"
;;   :tail-matcher "^```\n"
;;   :head-mode 'host
;;   :tail-mode 'host)


(define-auto-innermode my/poly-markdown-fenced-code-innermode
  :head-matcher (cons "^[ \t]*\\(```{?[[:alpha:]].*\n\\)" 1)
  ;;:head-matcher (cons "^[ \t]*\\(```.*\n\\)" 1)
  :tail-matcher (cons "^[ \t]*\\(```\\)[ \t]*$" 1)
  :mode-matcher (cons "```[ \t]*{?\\(?:lang *= *\\)?\\([^ \t\n;=,}:]+\\).*" 1)
  ;;:mode-matcher (cons "```[ \t]*{?\\(?:lang *= *\\)?\\([^ \t\n;=,}]+\\)" 1)
  :head-mode 'host
  :tail-mode 'host)

(define-polymode my/poly-markdown-mode
  :hostmode 'pm-host/markdown
  :innermodes '(my/poly-markdown-fenced-code-innermode))
  ;; :innermodes '(my/poly-python-innermode
  ;;               my/poly-markdown-fenced-code-innermode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . my/poly-markdown-mode))
(setq polymode-mode-name-override-alist '((elisp . emacs-lisp)))


;; 2020/01/22 shift選択でmarkdownのコードブロックをまたぐ場合の対処
(defadvice handle-shift-selection
  (around leave-mark-intact activate preactivate compile)
  (cond ((and shift-select-mode this-command-keys-shift-translated)
          (unless mark-active
            (setq transient-mark-mode
              (cons 'only
                (unless (eq transient-mark-mode 'lambda)
                  transient-mark-mode)))
            (push-mark nil nil t)))
    ((eq (car-safe transient-mark-mode) 'only)
      (setq transient-mark-mode (cdr transient-mark-mode))
      (deactivate-mark))))


(require 'tramp)
(setq tramp-default-method "sshx")


(defun ssh-shell ()
  (interactive)
  (setq conn (read-from-minibuffer "connection:"))
  (let ((tramp-mode t)(default-directory conn))
    (message conn)
    (call-interactively (shell conn))
  ))
(provide 'ssh-shell)

(defun ssh-zdc80 (n)
  (interactive "p")
  (let ((tramp-mode t)(default-directory "/scp:ohm_fg@192.168.5.8:/"))
  ;;(let ((tramp-mode t)(default-directory "/plink:ohm_fg@192.168.4.8:/"))
    (call-interactively (shell (concat "zdc80-shell" (number-to-string n))))
    ))
(provide 'ssh-zdc80)

;;(message (concat "test" (number-to-string 1)))

(defun ssh-zdc81 ()
  (interactive)
  (let ((tramp-mode t)(default-directory "/scp:ohm_fg@192.168.5.81:/"))
  ;;(let ((tramp-mode t)(default-directory "/plink:ohm_fg@192.168.4.81:/"))
    (call-interactively (shell "zdc81-shell"))
    ))
(provide 'ssh-zdc81)

(defun ssh-zdc82 ()
  (interactive)
  (let ((tramp-mode t)(default-directory "/scp:ohm_fg@192.168.5.82:/"))
  ;;(let ((tramp-mode t)(default-directory "/plink:ohm_fg@192.168.4.82:/"))
    (call-interactively (shell "zdc82-shell"))
    ))
(provide 'ssh-zdc82)

(require 'w3m)


(bind-keys :map w3m-mode-map
           ;;("TAB" . py-shift-right)
           ;;("<backtab>" . py-shift-left)
	   ;;("C-k" . py-comment-region)
;;	   ("C-K" . comment-dwim)
;;	   ([?\C-\S-h] . hello-world)
;;	   ("C-h" . hello-world2)
	   ;;("C-h" . er/expand-region)
	   ;;("C-S-h" . er/contract-region)
	   ;;("C-k t" . comment-region)
	   ("C-t" . nil)
	   ("<right>" . nil)
	   ("<left>" . nil)
	   ;;("C-t" . nil)
	   ("M-<RET>". w3m-view-this-url-new-session)
	   ("M-<left>". w3m-view-previous-page)
	   ("M-<right>". w3m-view-next-page)
	   ("<down>" . next-line)
	   ("<up>" . previous-line)
	   ("C-<down>" . w3m-next-anchor)
	   ("C-<up>" . w3m-previous-anchor)
	   ("C-h" . er/expand-region)
	   ;;("C-u" . er/contract-region)
	   ;;("C-n" . er/mark-python-block)
;;	   ("C-k C-k" . comment-dwim)
	   )

(defun my/w3m-display-hook(s)
  ;; (message "Hello Hook")
  ;; (message (w3m-current-title))
  ;;(rename-buffer (concat (buffer-name) (w3m-current-title)))
  (rename-buffer (concat "*w3m*" (w3m-current-title)))
  
  ;;(kill-buffer "*Mew message*0")
  ;;(delete-windows-on "*Mew message*0")
  ;;(mew-summary-toggle-disp-msg)
  ;;(kill-buffer "*Mew message*0")
  )

(add-hook 'w3m-display-hook 'my/w3m-display-hook)


;; 2020/09/19 markdownのタイトル間移動
(bind-keys :map poly-markdown-mode
	   ("M-<up>" . markdown-outline-previous)
	   ("M-<down>" . markdown-outline-next)
	   )

(defun test-markdown-eval-code ()
  (interactive)
  (let (
	(lang (shell-command-to-string
	       (format "md2code -s %s -l %s" (buffer-file-name) (line-number-at-pos))))
	(cmd (format "md2code %s -l %s" (buffer-file-name) (line-number-at-pos)))
	)
    (executable-interpret (format "bash -c \"%s| %s\"" cmd lang))
    )
  )

(provide 'test-markdown-eval-code)


(require 'org)
(setq org-support-shift-select t) ;; shift+カーソルでの選択を有効にする
(bind-keys :map org-mode-map
		   ("S-<right>" . nil)
		   ("S-<left>"  . nil)
		   ("C-S-<right>" . nil)
		   ("C-S-<left>"  . nil)
		   
		   ("M-<right>" . org-shiftright)
		   ("M-<left>"  . org-shiftleft)
		   )


(set-fontset-font t 'japanese-jisx0208 "azuki_font")
(setq face-font-rescale-alist '((".*azuki.*" . 1.15))) 

;; emacs27対応（set-default-fontは23でobsolete）
;;(set-default-font "Ubuntu Mono 12")
(set-frame-font "Ubuntu Mono 12")

;;(set-default-font "Consolas 12")
;;(set-fontset-font t 'japanese-jisx0208 "Myrica M")
;;(set-fontset-font t 'japanese-jisx0208 "TakaoGothic")
;;(set-fontset-font t 'japanese-jisx0208 "TakaoGothic")
;;(add-to-list 'default-frame-alist '(font . "TakaoGothic-12" ))
;;(add-to-list 'face-font-rescale-alist '(".*Takao.*" . 1.1)) ; OK
;;(add-to-list 'face-font-rescale-alist '(".*Takao.*" . 1.1)) ; OK
;;(add-to-list 'face-font-rescale-alist '(".*Takao.*" . 0.8)) ; OK
;;(add-to-list 'face-font-rescale-alist '(".*Myrica.*" . 1.1)) ; OK


(require 'smooth-scroll)
(smooth-scroll-mode t)


 ;;(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 ;; '(package-selected-packages
 ;;   (quote
 ;;    (htmlize 0blayout mew f nlinum smooth-scroll 2048-game "a" "a" "a" a helm "helm" "bind-key" "bindkeys" "bindkey" "bind-keys" "bind-key" "bind-keys" helm-ebdb org-mime skype browse-kill-ring yasnippet w3m volatile-highlights swoop semi recentf-ext python mmm-mode markdown-mode+ helm-swoop expand-region bind-key)))
 ;; '(send-mail-function (quote smtpmail-send-it))
 ;; '(smtpmail-smtp-server "127.0.0.1")
 ;; '(smtpmail-smtp-service 9999))


;;(require 'htmlize)
;;(require 'ob-shell))

(org-babel-do-load-languages 'org-babel-load-languages
    '(
        ;;(elixir . t)
        ;;(http . t)
        ;;(restclient . t)
        (python . t)
        ;;(plantuml . t)
        ;;(ruby . t)
        (emacs-lisp . t)
        ;;(sh . t)
    )
    )
(setq org-src-fontify-natively t)

;; ediffを左右分割にする
(setq ediff-split-window-function (quote split-window-horizontally))
(setq mew-mail-path "~/Mail")


;; ノートPC用タッチパッドoff 2019/03/31
(defun turn-off-mouse (&optional frame)
  (interactive)
  ;(shell-command "xinput --disable \"SynPS/2 Synaptics TouchPad\""))
  (shell-command "xinput --disable \"SYNP1F13:00 06CB:CD95 Touchpad\""))

(defun turn-on-mouse (&optional frame)
  (interactive)
  ;(shell-command "xinput --enable \"SynPS/2 Synaptics TouchPad\""))
  (shell-command "xinput --enable \"SYNP1F13:00 06CB:CD95 Touchpad\""))

;; 2020/06/16 ショートカットキーで切り替えることにする
;; (add-hook 'focus-in-hook #'turn-off-mouse)
;; (add-hook 'focus-out-hook #'turn-on-mouse)
;; (add-hook 'delete-frame-functions #'turn-on-mouse)




;; 2019年7月8日 oonishi 
(require 'company)
(global-company-mode) ; 全バッファで有効にする 
(setq company-idle-delay 0) ; デフォルトは0.5
(setq company-minimum-prefix-length 2) ; デフォルトは4
(setq company-selection-wrap-around t) ; 候補の一番下でさらに下に行こうとすると一番上に戻る
(add-hook 'shell-mode-hook '(lambda () (company-mode -1)))


;; 2019/07/20 自動インデントの挙動

(electric-indent-mode -1)
(defun my/indent(&optional a b)
  (interactive "r")
  (if (region-active-p)
      (python-indent-shift-right a b)
	  (insert "    ")))
(provide 'my/indent)

;;(define-key python-mode-map (kbd "<tab>") "    ")
(define-key python-mode-map (kbd "<tab>") 'my/indent)
(define-key python-mode-map (kbd "<S-iso-lefttab>") 'python-indent-shift-left)
(define-key python-mode-map (kbd "<return>") 'newline-and-indent)
;;(define-key markdown-mode-map (kbd "<tab>") "    ")
;; (define-key markdown-mode-map (kbd "<tab>") 'my/indent)
;; (define-key markdown-mode-map (kbd "<S-iso-lefttab>") 'python-indent-shift-left)
;; (define-key markdown-mode-map (kbd "<return>") 'newline-and-indent)


;; 2019/08/07 mewの設定
;; evernote用メールをhtmlで見る

(require 'mew)
(require 'eww)
(setq mew-mime-multipart-alternative-list '("Text/Html" "Text/Plain" ".*"))
;; (setq mew-mime-multipart-alternative-list '("Text/Html" ".*"))
;; ;;(add-hook 'mew-message-hook 'w3m-minor-mode)
;;(add-hook 'mew-message-hook 'markdown-mode)
;;(setq mew-file-max-size 10000000)

(setq mew-prog-text/html 'eww-region)
(setq mew-prog-text/xml 'eww-region)
(setq mew-use-text/html t)
;; (advice-add 'shr-colorize-region :around 'shr-colorize-region--disable)
;; (advice-add 'eww-colorize-region :around 'shr-colorize-region--disable)

(when (and (fboundp 'shr-render-region)
           ;; \\[shr-render-region] requires Emacs to be compiled with libxml2.
           (fboundp 'libxml-parse-html-region))
  (setq mew-prog-text/html 'shr-render-region)) ;; 'mew-mime-text/html-w3m


(setq shr-color-visible-luminance-min 0)
(setq mew-highlight-body-regex-comment "^0#0#0#0#0#0#0#0#0#0#0#$")
(setq mew-highlight-body-regex-cite "^0#0#0#0#0#0#0#0#0#0#0#0$")


;; 2019/08/10 全面的に修正した
;; ;; 2019/07/20 markdownをevernoteに送る
;; (defun my/cut-subtree (tmpname)
;; 	(interactive)
;;   (let ((new (generate-new-buffer "*test*")))

;; 	(markdown-mark-subtree)
;; 	(setq aaa (buffer-substring-no-properties (region-beginning) (region-end)))
;;   (with-current-buffer new
;;     ;;(message "----------test")	
;; 	(insert aaa)
;; 	(write-file tmpname)
;; 	)
;;   (kill-buffer new)
;;   )
;; )
;; (provide 'my/cut-subtree)

;; (defun my/send-evernote()
;;   (interactive)
;;   (my/cut-subtree "/tmp/temp.md")
;;   (shell-command-to-string "md2mime --attachdir . /tmp/temp.md|send-evernote --passwd IOKlLBuAFPVo5xGQWs")
;;   )
;; (provide 'my/send-evernote)

(defun my/send-evernote()
  (interactive)
  (let ((process-connection-type nil)
        (proc-name "test<3>"))
    (start-process proc-name nil "md2code" "/home/owner/app/send-evernote.md" "-n" "main")

    ;;(switch-to-buffer-other-window "*test*")
    ;; (set-process-buffer (get-process proc-name) (generate-new-buffer "*test*"))
	(set-process-buffer (get-process proc-name) (get-buffer "*Message*"))
	(if (not (region-active-p))
		(markdown-mark-subtree)
	)
	(process-send-region proc-name (region-beginning) (region-end))
	(process-send-eof proc-name)
))
(provide 'my/send-evernote)

(defun my/send-evernote-wsl()
  (interactive)
  (let(
       (process-environment
        (append  process-environment '("TMPDIR=/mnt/c/tmp")))  )
    ;;(message "yes")
    (my/send-evernote))
)

(provide 'my/send-evernote-wsl)


;; (defun my/send-evernote()
;;   (interactive)
;;   (my/cut-subtree "/tmp/temp.md")
;;   (shell-command-to-string "md2mime --attachdir . /tmp/temp.md|send-evernote --passwd IOKlLBuAFPVo5xGQWs")
;;   )
;; (provide 'my/send-evernote)

;; 2019/07/20 mozcの設定

;;変換候補をmini-bufferに出す
(setq mozc-candidate-style 'echo-area) 
;;変換候補をpopupで出す（重い）
;;(setq mozc-candidate-style 'overlay)   
;; helm でミニバッファの入力時に IME の状態を継承しない
(setq helm-inherit-input-method nil)

;; 2020/01/22 ターミナルモードで半角スペースがうてない問題の対処
(defun my/mozc-spc()
  (interactive)
  (if mozc-preedit-in-session-flag
	(mozc-handle-event 32)
	(insert " ")
	)
)
(define-key mozc-mode-map (kbd "SPC") 'my/mozc-spc)


;; 2019/07/21 mewのevernoteを検索する
(require 'cl)
(require 'mew)
(defun my/evernote-search ()
  (interactive)
  ;;(let ((mew-summary-folder-name  "aaaa"))
  ;;(flet ((mew-case-folder (a b) "%evernote"))
  ;;(flet ((mew-input-folders  (a) (list "%evernote"))
  (flet ((mew-input-folders (a) (list "+inbox/evernote"))
	 (mew-input-pick-pattern (a) "")
	 )
    (mew-summary-selection-by-search 1)
    )
  )
(provide 'my/evernote-search)


;; 2019/08/12 markdownのコードブロックを実行
(defun my/md2code()
  (interactive)
  (let(
	   (lno (line-number-at-pos (point))))
	(setq my/md2code--last-lineno lno)
	(save-buffer)
	(executable-interpret (format "md2code %s --keep-lineno -l %d " (buffer-file-name) lno))
	
))
(provide 'my/md2code)



;; emacs-serverを起動する。
;; 直接は関係ないが後述のシェルでemacs-lispを実行するために必要
(server-start)




(defun my/md2code-again()
  (interactive)
  (let(
	   (lno my/md2code--last-lineno))
	(save-buffer)
	(executable-interpret (format "md2code %s --keep-lineno -l %d " (buffer-file-name) lno))
	
))
(provide 'my/md2code-again)


;; 2019/08/14 mewのevernoteフォルダを更新して開く
(defun my/open-evernote-mail ()
  (interactive)
  (mew)
  ;;(mew-summary-switch-to-folder "+inbox/evernote")
  (mew-summary-visit-folder "+inbox/evernote")
  (shell-command-to-string "sylpheed --receive")
  (message (buffer-name (current-buffer)))
  ;;(sleep-for 2)
  (mew-summary-ls t t t)
  (mew-summary-make-index-folder)
)

(provide 'my/open-evernote-mail)


;; 2019/10/05 mewを横分割にする
;;(require 'mew)
;;(require 'cl)
(defadvice mew-window-configure (around my-foo2 activate)
  (flet (
         (split-window  (a b) nil)
         (delete-windows-on (&optional a) nil)
         )
    ;;(message "yes")
    ad-do-it
    ;;(message "yes2")
))


;; 2019/10/05 html表示のメールをText表示にする
(defun my/plain-text-mail ()
  (interactive)
  ;;(defvar-local mew-mime-multipart-alternative-list '("Text/Plain" ".*"))
  (let (
        (mew-mime-multipart-alternative-list '("Text/Plain" ".*")))
    (mew-summary-analyze-again)
    )
)
(provide 'my/plain-text-mail)


;; 2020/02/12 shモードで"<<" が勝手に"<<EOF"に補完される件の対応
(remove-hook 'sh-mode-hook 'sh-electric-here-document-mode)


;;(setq indent-tabs-mode nil)
(add-hook 'markdown-mode-hook (lambda () (setq indent-tabs-mode nil)))


(tool-bar-mode 0)
;;(menu-bar-mode 1)
(display-time)


;; 2020/09/21
(defun my/align ()
  (interactive)
  ;;(align-regexp (region-beginning) (region-end) "\\s+\\([^ ]\\)" 1 1 t)
  ;;(replace-string "timestamp with time zone" "timestamp_with_time_zone" " " (region-beginning) (region-end))
  (let ((indent-tabs-mode nil))
	(align-regexp (region-beginning) (region-end) "\\([ ]\\)[^ ]" 1 1 t)
  )
  ;;(replace-string "timestamp_with_time_zone" "timestamp with time zone" " " (region-beginning) (region-end))
)
(provide 'my/align)



(defun my/unalign()
  (interactive)
  ;;(replace-string "timestamp with time zone" "timestamp_with_time_zone" " " (region-beginning) (region-end)))
  (replace-regexp " +" " "  nil (region-beginning)  (region-end)))
(provide 'my/my/align)


;; 2020/10/02 パスワード入力はshellでやったほうが使いやすい
(setq comint-password-prompt-regexp "#123456789-----------------")

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["#242424" "#e5786d" "#D0A0A0" "#cae682" "#A0FFD0" "#333366" "#ccaa8f" "#f6f3e8"])
 '(cua-mode t nil (cua-base))
 '(custom-safe-themes
   '("e1ef2d5b8091f4953fe17b4ca3dd143d476c106e221d92ded38614266cea3c8b" "fa3bdd59ea708164e7821574822ab82a3c51e262d419df941f26d64d015c90ee" "cb96a06ed8f47b07c014e8637bd0fd0e6c555364171504680ac41930cfe5e11e" "2cdc13ef8c76a22daa0f46370011f54e79bae00d5736340a5ddfe656a767fddf" "a038af4fff7330f27f4baec145ef142f8ea208648e65a4b0eac3601763598665" "74a42b2b5dde1057e66bcf4c241789213e0ed5b77a2ee41c982fdc8c2abe9d98" "d5f8099d98174116cba9912fe2a0c3196a7cd405d12fa6b9375c55fc510988b5" "d261bb8f66be37752791a67f03dd24361592ce141b32d83bcbe63ec1c738b087" "e074be1c799b509f52870ee596a5977b519f6d269455b84ed998666cf6fc802a" "1ed5c8b7478d505a358f578c00b58b430dde379b856fbcb60ed8d345fc95594e" "88a3c267ce2132defd46f2a4761925983dcbc35b1c3cfff1dded164ce169fed4" "845103fcb9b091b0958171653a4413ccfad35552bc39697d448941bcbe5a660d" "6bacece4cf10ea7dd5eae5bfc1019888f0cb62059ff905f37b33eec145a6a430" "c83c095dd01cde64b631fb0fe5980587deec3834dc55144a6e78ff91ebc80b19" "6e2d579b02aadc933f434003f49d269d004f5c7094eb53658afbacc817761d83" "4daff0f7fb02c7a4d5766a6a3e0931474e7c4fd7da58687899485837d6943b78" "229c5cf9c9bd4012be621d271320036c69a14758f70e60385e87880b46d60780" "be9645aaa8c11f76a10bcf36aaf83f54f4587ced1b9b679b55639c87404e2499" "774aa2e67af37a26625f8b8c86f4557edb0bac5426ae061991a7a1a4b1c7e375" "99ea831ca79a916f1bd789de366b639d09811501e8c092c85b2cb7d697777f93" "0809c08440b51a39c77ec5529f89af83ab256a9d48107b088d40098ce322c7d8" "ec8246f6f74bfe0230521412d88092342c17c1c0448a4b8ba39bddd3da170590" "559b28ae6deb74713fee9064e7ece54cb71ba645f44acbf81ad7916a4f947815" "1c8171893a9a0ce55cb7706766e57707787962e43330d7b0b6b0754ed5283cda" "bc836bf29eab22d7e5b4c142d201bcce351806b7c1f94955ccafab8ce5b20208" "d5aba84e993dfa0be5ddd92b49043b64a7b979ac3fc9ce6df1e2b765be7e65a2" "dd8681f25482142560b350fadbc53da578f920541f3ec5352355850d3623751b" default))
 '(default-input-method "japanese-mozc")
 '(display-time-mode t)
 '(fci-rule-color "#BA45A3")
 '(global-display-line-numbers-mode t)
 '(jdee-db-active-breakpoint-face-colors (cons "#131033" "#1ea8fc"))
 '(jdee-db-requested-breakpoint-face-colors (cons "#131033" "#a7da1e"))
 '(jdee-db-spec-breakpoint-face-colors (cons "#131033" "#546A90"))
 '(objed-cursor-color "#e61f44")
 '(package-selected-packages
   '(tmux-pane docker-compose-mode docker-tramp ialign yaml-mode dokuwiki-mode undo-tree undohist csv-mode ggtags helm-gtags global-tags monky quelpa jump-tree evil dockerfile-mode mozc-cand-posframe doom-themes gnu-elpa-keyring-update highlight-thing magit swiper mew seml-mode company mozc-temp exwm fish-completion google-translate goose-theme lua-mode multifiles sudoku poly-markdown yascroll bash-completion multi-term latex-math-preview fish-mode yasnippet w3m volatile-highlights swoop smooth-scroll skype semi recentf-ext python org-mime nlinum mmm-mode markdown-mode+ htmlize helm-swoop helm-ebdb f expand-region browse-kill-ring bind-key a 2048-game 0blayout))
 '(pdf-view-midnight-colors (cons "#f2f3f7" "#0c0a20"))
 '(show-paren-mode t)
 '(tool-bar-mode nil)
 '(vc-annotate-background "#0c0a20")
 '(vc-annotate-color-map
   (list
    (cons 20 "#a7da1e")
    (cons 40 "#c4d814")
    (cons 60 "#e1d60a")
    (cons 80 "#ffd400")
    (cons 100 "#efa314")
    (cons 120 "#df7329")
    (cons 140 "#cf433e")
    (cons 160 "#df3a7d")
    (cons 180 "#ef32bc")
    (cons 200 "#ff2afc")
    (cons 220 "#f626be")
    (cons 240 "#ee2281")
    (cons 260 "#e61f44")
    (cons 280 "#c13157")
    (cons 300 "#9d4469")
    (cons 320 "#78577d")
    (cons 340 "#BA45A3")
    (cons 360 "#BA45A3")))
 '(vc-annotate-very-old-color nil))

(put 'upcase-region 'disabled nil)
