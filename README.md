# test
http://www.eco-lead.jp/hitozukuri_seminar_2020/

- nodoka
- clibor
- BandiCam or IPMsg
- notepad++ 32bit
- sakura
- vscode
- wsl
- python
- As/r or Tablacus
- QGIS
- SuperMap
- X410
- wsltty


# test

```elisp
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
                   ;; リモート実行用緊急対応 2020/11/12
                   ;;(format "mdcoderun %s --keep-lineno -l %d --run|cat" (my/buffer-file-name) lno))))
                   (format "bash -l -c 'mdcoderun %s --keep-lineno -l %d --run'|cat" (my/buffer-file-name) lno))))

      (let* (
		   (process-environment (append  
								 process-environment '("MDCODERUN_LANG2EXEC=elisp=emacsclient -e '(load \"{}\")',emacs-lisp=emacsclient -e '(load \"{}\")'")))
	   (process-connection-type nil)
           (lno (line-number-at-pos (point)))
           (buf  (executable-interpret (format "bash -l -c 'mdcoderun --keep-lineno -l %d --run'|cat" lno)))
           (proc (get-buffer-process buf)))

      ;;(process-send-string proc "test\n")
      ;;(process-send-region proc (point-min) (point-max))
      (process-send-string proc (substring-no-properties (buffer-string) 0))
      (process-send-string proc "\n")
      (process-send-eof proc)
      ;;(or (get-buffer "*interpretation*") (generate-new-buffer "*interpretation*"))
      ))
 )

```

# emacs: タブスペースを表示する

サクラエディタみたいに色の薄い"^"で表示する

```elisp
	
(progn
  (require 'whitespace)
  (setq whitespace-style
        '(
          face ; faceで可視化
          tabs ; タブ
          ;;space-mark ; 表示のマッピング
          tab-mark
          ))
  (setq whitespace-display-mappings
        '(
          ;;(space-mark ?\u3000 [?\u2423])
          ;;(tab-mark ?\t [?\u005E ?\t] [?\\ ?\t])
          (tab-mark ?\t [?\u005E ?\t ?\u007C] [?\\ ?\t])
          ))
  (setq whitespace-trailing-regexp  "\\([ \u00A0]+\\)$")
  (setq whitespace-space-regexp "\\(\u3000+\\)")

  (set-face-attribute 'whitespace-trailing nil
                      :foreground "RoyalBlue4"
                      :background "RoyalBlue4"
                      :underline nil)
  (set-face-attribute 'whitespace-tab nil
                      :foreground "grey60"
                      :background "grey20"
                      :underline nil)
  (set-face-attribute 'whitespace-space nil
                      :foreground "gray40"
                      :background "gray20"
                      :underline nil)
  (global-whitespace-mode t)
  )
	
```
