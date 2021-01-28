# test

```python : test.py
print('yes')
```

- test
    ```bash : test.bash
    echo yes
    ```

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


# markdownのhtmlメール化

2021/01/26

検討中
----

~~~md

# test

```python
import test
print('yes')
```

- test
    ```bash : name
    export TEST
	echo $TEST
    ```
- test2
~~~

```js
const program = require("commander");
const fs = require("fs");
// markedモジュールをmarkedオブジェクトとしてインポートする
const marked = require("marked");

program.parse(process.argv);
const filePath = program.args[0];

fs.readFile(filePath, { encoding: "utf8" }, (err, file) => {
    if (err) {
        console.error(err.message);
        process.exit(1);
        return;
    }
    // MarkdownファイルをHTML文字列に変換する
    const html = marked(file, {gfm:true});
    console.log(html);
});
```

```bash
cd /tmp/test
mdcoderun [::this::] -i [::index,-2::] --show > test.md
mdcoderun [::this::] -i [::index,-1::] --show > test.js
cat <<EOF
<html>
<header>
<link rel="stylesheet" 
href="//cdnjs.cloudflare.com/ajax/libs/highlight.js/9.15.10/styles/default.min.css">
<script src="//cdnjs.cloudflare.com/ajax/libs/highlight.js/9.15.10/highlight.min.js"></script>
<script>hljs.initHighlightingOnLoad();</script>
</header>
<body>
EOF

node test.js test.md

cat <<EOF
</body>
</html>
EOF

```

# latex環境のセットアップ中

2021/01/28

-----


```Dockerfile
FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y

RUN apt install dvipng  -y
RUN apt install latexmk -y
RUN apt install mathtex -y
RUN apt install texlive-full -y
```

```bash
rm -r /tmp/test.d
mkdir /tmp/test.d
cd    /tmp/test.d
mdcoderun [::this::] -i [::index,-1::] --show > Dockerfile
docker build \
       --build-arg HTTPS_PROXY=$HTTPS_PROXY \
       --build-arg HTTP_PROXY=$HTTP_PROXY   \
       . -t test-image
```

```
asymptote
biber
chktex
cm-super (>= 0.3.3-3)
context
dvidvi
dvipng
feynmf
fragmaster
info (>= 4.8)
lacheck
latex-cjk-all (>= 4.6.0+cvs20060714-2)
latexdiff
latexmk
lcdf-typetools
lmodern (>= 0.93.3)
prerex (>> 6.5.3-1)
psutils
purifyeps
t1utils
tex-gyre
texinfo (>= 4.8)
texlive-base (>= 2017.20170628)
texlive-bibtex-extra (>= 2017.20170628)
texlive-binaries (>= 2017.20170524.44437)
texlive-extra-utils (>= 2017.20170628)
texlive-font-utils (>= 2017.20170628)
texlive-fonts-extra (>= 2017.20170628)
texlive-fonts-extra-links (>= 2017.20170628)
texlive-fonts-recommended (>= 2017.20170628)
texlive-formats-extra (>= 2017.20170628)
texlive-games (>= 2017.20170628)
texlive-humanities (>= 2017.20170628)
texlive-lang-arabic (>= 2017.20170628)
texlive-lang-chinese (>= 2017.20170628)
texlive-lang-cjk (>= 2017.20170628)
texlive-lang-cyrillic (>= 2017.20170628)
texlive-lang-czechslovak (>= 2017.20170628)
texlive-lang-english (>= 2017.20170628)
texlive-lang-european (>= 2017.20170628)
texlive-lang-french (>= 2017.20170628)
texlive-lang-german (>= 2017.20170628)
texlive-lang-greek (>= 2017.20170628)
texlive-lang-italian (>= 2017.20170628)
texlive-lang-japanese (>= 2017.20170628)
texlive-lang-korean (>= 2017.20170628)
texlive-lang-other (>= 2017.20170628)
texlive-lang-polish (>= 2017.20170628)
texlive-lang-portuguese (>= 2017.20170628)
texlive-lang-spanish (>= 2017.20170628)
texlive-latex-base (>= 2017.20170628)
texlive-latex-extra (>= 2017.20170628)
texlive-latex-recommended (>= 2017.20170628)
texlive-luatex (>= 2017.20170628)
texlive-metapost (>= 2017.20170628)
texlive-music (>= 2017.20170628)
texlive-pictures (>= 2017.20170628)
texlive-plain-generic (>= 2017.20170628)
texlive-pstricks (>= 2017.20170628)
texlive-publishers (>= 2017.20170628)
texlive-science (>= 2017.20170628)
texlive-xetex (>= 2017.20170628)
tipa (>= 2:1.2-2.1)
vprerex (>> 6.5.3-1)
xindy


```bash
mdcoderun [::this::] -i [::index,-1::] --show \
  | awk '(a++%2){print $0}'
```


```
\documentclass{jsarticle}
\usepackage{bigints}
\usepackage{amsmath}
\begin{document}
\pagestyle{empty}
\[
 \bigint \cfrac{1}{\sqrt{2\pi \sigma^2}}
 \exp\left(-\cfrac{\left(x-\mu \right)^2}{2\sigma^2} \right)  \, \mathrm{d}x
\]
\end{document}

```

platex dvipng の順に実行



