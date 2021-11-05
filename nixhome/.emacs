;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  My init file for GNU Emacs
;;  Author: Leiqin Lu
;;  July 07, 2000
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

;; Tell emacs where is your personal elisp lib dir
(add-to-list 'load-path "~/.emacs.lisp/")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Run as server ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; run emacs in server mode so as emacsclient can connect to:
(require 'server)
  (unless (server-running-p)
    (server-start))
;; Gnu Server
;(if (eq system-type 'windows-nt)
;    (progn (require 'gnuserv)
;    (gnuserv-start)
;    (setq gnuserv-frame (selected-frame))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Define variables ;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; disable startup message: 
(setq inhibit-startup-message t)

;; change working path:
(cd "~/")

;; set shell type:
;(setq shell-file-name "bash")

;; set default and initial major mode:
(setq default-major-mode 'text-mode)
; (setq initial-major-mode 'ielm)

;; set auto-mode:
(setq auto-mode-alist 
      (append '(
    ("\\.\\(gr\\|v\\)xml\\'" . sgml-mode) ;; XML files
    ("\\.exe\\'" . hexl-mode) ;; binary files
    ) auto-mode-alist))

;; enable auto-compression:
(auto-compression-mode t)

;; set indentation:
(setq-default indent-tabs-mode nil)
(setq-default tab-width 2)
(setq default-tab-width 2)

;; use aspell instead of ispell:
(setq-default ispell-program-name "aspell")

;; set colors:
(set-background-color "white")
(set-foreground-color "black")

;; set show-paren-mode:
(show-paren-mode t)
(setq show-paren-delay 0.001)
;; highlight the whole expression inside the paren pair:
; (setq show-paren-style 'expression)

;; set font-lock-mode:
(global-font-lock-mode t)
(setq font-lock-maximum-decoration t)
(setq font-lock-support-mode 'jit-lock-mode)

;; no backup files:
(setq make-backup-files nil)

;; global-auto-revert-mode:
(global-auto-revert-mode 1)

;; set frame line, mode line, header line:
(setq frame-title-format '("[" user-login-name "@" system-name "] %f"))
; (setq default-header-line-format (quote ("%f")))
(setq default-mode-line-format (quote ("-" mode-line-mule-info mode-line-modified mode-line-frame-identification (20 "(%l-%c %p-%i) ") #("%b >> %f" 0 2 (help-echo (buffer-file-name))) (vc-mode vc-mode) "   "  mode-line-modes (which-func-mode ("" which-func-format "--")) (global-mode-string ("--" global-mode-string)) "-%-")))
;; show line/column number in mode line:
(setq line-number-display-limit nil) ; always display line number, no matter how large the buffer is.
(line-number-mode t) ; it is on by default. Not used in my mode line format.
(column-number-mode t) ; it is off by default. Not used in my mode line format.
; (size-indication-mode t) ; display buffer size in mode line. it is off by default. Not used currently because I customized default-mode-line-format.
; (display-time-mode t) ; show time in mode line.

;; set mode-line-format:

;; don't move cursor to center of frames automatically:
(setq scroll-step 1)
(setq scroll-conservatively 1)

;; destop auto-saving:
;(load "desktop")
;(desktop-load-default)
;(desktop-read) ; desktop auto-reloading when startup
;(add-hook 'kill-emacs-hook '(lambda()(desktop-save "~/"))) ;当emacs退出时保存 ~/desktop 文件记录状态

;; set scroll-bar-mode:
;(hscroll-global-mode t)

;; stop at end of files:
(setq next-line-add-newlines nil)

;; query before exit:
(setq kill-emacs-query-functions
     (cons (lambda () (yes-or-no-p "Really kill Emacs?"))
     kill-emacs-query-functions))

;; select a tags table:
; (setq tags-table-list '("path1" "path2"))
; (setq tags-file-name "path")

;; customize calendar and diary:
;; I like neither european style (M-x european-calendar) nor american style (M-x american-calendar).
;; so I set my preferred ISO 8601 standard representation:
(setq diary-file "~/log/log.xml")
(setq calendar-date-display-form '(year "-" month "-" day)) ;; to show in calendar, diary, mode line, etc.
(setq diary-date-forms '((year "-" month "-" day) ("<node +when=\"" year "-" month "-" day "[^>]+>"))) ;; so that diary also recognizes ISO 8601 format and my XML log format. More formats for european/american styles can be added to this list.

;; undo-tree
(require 'undo-tree)
(global-undo-tree-mode)
(defalias 'redo 'undo-tree-redo)

;; If non-nil, copy to kill-ring upon mouse adjustments of the region. 如果不是空（non-nil），则将鼠标选中区域复制到 kill-ring。
(setq mouse-drag-copy-region t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Define functions ;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; kill all buffers at once:
(defun kill-all-buffers ()
  "Kill all buffers, leaving *scratch* only"
  (interactive)
  (mapcar (lambda (x) (kill-buffer x)) (buffer-list))
  (delete-other-windows))

;; ps-print to file:
(defun ps-print-to-file ()
  "Print to file"
  (interactive)
  (ps-print-buffer 
   (read-string "Print to file: " 
    (concat buffer-file-name ".ps"))))
(defun ps-print-to-file-with-faces ()
  "Print to file with faces"
  (interactive)
  (ps-print-buffer-with-faces 
   (read-string "Print to file with faces: " 
    (concat buffer-file-name ".ps"))))

;; save as file:
(defun save-as-file ()
  "Save as file"
  (interactive)
  (write-file
   (read-string "Save as:"
    (concat buffer-file-name ".")) t))

;; activate appointmens:
(defun activate-appointments ()
  "Activate appointments"
  (interactive)
  (appt-activate 1))
       
;; rotate buffers:
(defun rotate-buffer ()
  "Rotate all buffers"
  (interactive)
  (progn (bury-buffer) (switch-to-buffer (current-buffer))))

;; rotate buffers:
(defun shift-buffer ()
  "Switch between current and the most recent buffers"
  (interactive)
  (progn (bury-buffer) (switch-to-buffer (current-buffer))))

;; jump to the matching parenthesis:
(defun match-paren ()
  "Jump to the matching parenthesis"
  (interactive)
  (cond ((looking-at "\\s\(") (forward-list 1) (backward-char 1))
  ((looking-at "\\s\)") (forward-char 1) (backward-list 1))))

;; switch between truncation and continuation mode for line wrapping:
(defun switch-truncation-continuation ()
  "Switch between truncation and continuation mode for line wrapping"
  (interactive)
  (setq truncate-lines (not truncate-lines))
  (setq truncate-partial-width-windows truncate-lines)
  ; changes to truncate-??? variables don't take effect immediately,
  ; so do something else to apply the changes:
  (font-lock-fontify-buffer))

;; open a new shell:
(defun new-shell ()
  "Create a new shell"
  (interactive)
  (progn (rename-uniquely) (shell)))
(defun new-eshell ()
  "Create a new eshell"
  (interactive)
  (progn (rename-uniquely) (eshell)))

;; user specific function to do something:
(defun do-something-here ()
  "Do something here"
  (interactive)
  (do-something-here-hook))

;; not a real hook by means of emacs hook variables.
;; default hook. Should be redefined for user purpose:
(defun do-something-here-hook ()
  "Do something here hook"
  (interactive)
  (copy-region-as-kill (line-beginning-position)
           (line-end-position))
  (message "Default action: copied the current line"))

;; set start mark at current position. euqual to C-Space.
;(defun push-mark-here ()
;  "An interactive wrapper of push-mark"
;  (interactive)
;  (push-mark))

;; set-language-environment hook:
(defun configure-langenv ()
  "Setup my favorite language environments"
  (cond 
;   ((equal current-language-environment "Chinese-GB") (setq default-input-method "chinese-tonepy"))
   ((equal current-language-environment "UTF-8") (setq default-input-method "chinese-py-punct"))
   ))
(add-hook 'set-language-environment-hook 'configure-langenv)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Define keys ;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; F1 file
(global-set-key [f1] 'find-file)
(global-set-key (kbd "C-o") 'find-file) ; windows style
  (global-set-key [S-f1] 'save-buffer)
  (global-set-key [f13] 'save-buffer)
  (global-set-key (kbd "C-s") 'save-buffer) ; windows style
    (global-set-key [C-f1] 'save-as-file) ; ps-print-to-file
    (global-set-key [f25] 'save-as-file)
;; F2 buffer
(global-set-key [f2] 'rotate-buffer)
  (global-set-key [S-f2] 'list-buffers) ; switch-to-buffer
  (global-set-key [f14] 'list-buffers)
    (global-set-key [C-f2] 'kill-this-buffer) ; kill-buffer prompts before killing.
    (global-set-key [f26] 'kill-this-buffer)
;; F3 search
(global-set-key [f3] 'isearch-forward)
(global-set-key (kbd "C-f") 'isearch-forward) ; windows style
  (global-set-key [S-f3] 'isearch-forward-regexp)
  (global-set-key [f15] 'isearch-forward-regexp)
  (global-set-key (kbd "S-f") 'isearch-forward-regexp) ; windows style
    (global-set-key [C-f3] 'how-many)
    (global-set-key [f27] 'how-many)
    (global-set-key (kbd "C-S-f") 'how-many) ; windows style
;; F4 replace
(global-set-key [f4] 'query-replace)
  (global-set-key [S-f4] 'query-replace-regexp)
  (global-set-key [f16] 'query-replace-regexp)
    (global-set-key [C-f4] 'kill-region) ; default: C-w. copy-region-as-kill default M-w. ;(global-set-key (kbd "C-c") ') ; windows style. doens't work.
    (global-set-key [f28] 'kill-region)
;    (global-set-key (kbd "C-x") 'kill-region) ; windows style. doesn't work.
;; F5 paste. 在 windows 上，cmd 作为 shell 时，输出的中文是乱码。而 eshell 能正确输出中文。
(global-set-key [f5] 'yank)  ; default: C-y
(global-set-key (kbd "C-v") 'yank) ; windows style
  (global-set-key [S-f5] 'yank-top) ; default: M-y for along the ring
  (global-set-key [f17] 'yank-top)
;    (global-set-key [C-f5] ')
;    (global-set-key [f29] ')
;; F6 go
(global-set-key [f6] 'goto-line)
  (global-set-key [S-f6] 'match-paren)
  (global-set-key [f18] 'match-paren)
    (global-set-key [C-f6] 'other-window)
    (global-set-key [f30] 'other-window)
;; F7 internationalization
(global-set-key [f7] 'toggle-input-method)
  (global-set-key [S-f7] 'what-cursor-position) ; switch-truncation-continuation
  (global-set-key [f19] 'what-cursor-position)
    (global-set-key [C-f7] 'describe-char)
    (global-set-key [f31] 'describe-char)
;; F8 undo&redo
(global-set-key [f8] 'undo) ; default: C-_ , C-x u; or entering M-x undo
(global-set-key (kbd "C-z") 'undo) ; windows style. [C-z] doesn't work, maybe because it's default to suspend-frame
  (global-set-key [S-f8] 'redo)
  (global-set-key [f20] 'redo)
  (global-set-key (kbd "C-y") 'redo) ; windows style. [C-y] doesn't work.
  (global-set-key (kbd "C-S-z") 'redo) ; mac style. [C-S-z] doesn't work.
;    (global-set-key [f32] ')
;; F9 shell
(global-set-key [f9] 'eshell)
  (global-set-key [S-f9] 'new-eshell)
  (global-set-key [f21] 'new-eshell)
    (global-set-key [C-f9] 'browse-web)
    (global-set-key [f33] 'browse-web)
;; F10 
;(global-set-key [f10] ')
;  (global-set-key [S-f10] ')
;  (global-set-key [f22] ')
;    (global-set-key [C-f10] ')
;    (global-set-key [f34] ')
;; F11 tool
(global-set-key [f11] 'calculator)
  (global-set-key [S-f11] 'calendar)
  (global-set-key [f23] 'calendar)
    (global-set-key [C-f11] 'activate-appointments)
    (global-set-key [f35] 'activate-appointments)
;; F12 
(global-set-key [f12] 'other-window)
  (global-set-key [S-f12] 'suspend-frame)
  (global-set-key [f24] 'suspend-frame)
;    (global-set-key [C-f12] 'kill-emacs)
;    (global-set-key [f36] 'kill-emacs)

;; jumping cursors
(global-set-key [home] 'beginning-of-line)
  (global-set-key [S-home] 'beginning-of-buffer)
(global-set-key [end] 'end-of-line)
  (global-set-key [S-end] 'end-of-buffer)

;; page down/up to search repeatly
(define-key isearch-mode-map [next]
  'isearch-repeat-forward)
(define-key isearch-mode-map [prior]
  'isearch-repeat-backward)

;; 修改字体大小:
;; For Linux
(global-set-key (kbd "<C-mouse-4>") 'text-scale-increase)
(global-set-key (kbd "<C-mouse-5>") 'text-scale-decrease)
;; For Windows
(global-set-key (kbd "<C-wheel-up>") 'text-scale-increase)
(global-set-key (kbd "<C-wheel-down>") 'text-scale-decrease)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Dired mode ;;;;;;;;;;;;;;;;;;;;;;;;;
;; For dired mode. The switches are passed to "ls" or the ls-list package on Windows.
;; Therefore, Dired on Windows supports only some of the possible options: AacirSstu.
;; 'F': adds '/' to directory, '*' to executable file, '@' to symbolic link;
;; 'G': don't display group info; Note: in Windows, -go takes no effect, so add -G.
;; 'l': long listing format;
;; 'g': long listing format without owner info; ignored in some systems;
;; 'o': long listing format without group info.
;; 'U': unsort. In windows, names are already sorted alphabetically and case-insensitively by default, 
;;   so U should be used in windows to disable case-sensitive sorting.
;;   In unix, names are unsorted by default. So U shouldn't be used.
(if (eq system-type 'windows-nt)
    (setq dired-listing-switches "-alU")
  (setq dired-listing-switches "-al --time-style=long-iso --color=auto"))

;;;;;;;;;;;;;;;;;;;;;;;;;;; Setup AUCTeX ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(if (eq system-type 'windows-nt)
    (progn 
      ;; use yap instead of xdvi in windows:
      (setq TeX-output-view-style (quote (("^dvi$" ("^landscape$" "^pstricks$\\|^pst-\\|^psfrag$") "%(o?)dvips -t landscape %d -o && gv %f") ("^dvi$" "^pstricks$\\|^pst-\\|^psfrag$" "%(o?)dvips %d -o && gv %f") ("^dvi$" ("^a4\\(?:dutch\\|paper\\|wide\\)\\|sem-a4$" "^landscape$") "%(o?)yap %dS -paper a4r -s 0 %d") ("^dvi$" "^a4\\(?:dutch\\|paper\\|wide\\)\\|sem-a4$" "%(o?)yap %dS -paper a4 %d") ("^dvi$" ("^a5\\(?:comb\\|paper\\)$" "^landscape$") "%(o?)yap %dS -paper a5r -s 0 %d") ("^dvi$" "^a5\\(?:comb\\|paper\\)$" "%(o?)yap %dS -paper a5 %d") ("^dvi$" "^b5paper$" "%(o?)yap %dS -paper b5 %d") ("^dvi$" "^letterpaper$" "%(o?)yap %dS -paper us %d") ("^dvi$" "^legalpaper$" "%(o?)yap %dS -paper legal %d") ("^dvi$" "^executivepaper$" "%(o?)yap %dS -paper 7.25x10.5in %d") ("^dvi$" "." "%(o?)yap %dS %d") ("^pdf$" "." "xpdf -remote \"%s\" -raise %o %(outpage)") ("^html?$" "." "netscape %o"))))
      (setq TeX-view-style (quote (("^a4\\(?:dutch\\|paper\\|wide\\)\\|sem-a4$" "%(o?)yap %dS -paper a4 %d") ("^a5\\(?:comb\\|paper\\)$" "%(o?)yap %dS -paper a5 %d") ("^b5paper$" "%(o?)yap %dS -paper b5 %d") ("^letterpaper$" "%(o?)yap %dS -paper us %d") ("^legalpaper$" "%(o?)yap %dS -paper legal %d") ("^executivepaper$" "%(o?)yap %dS -paper 7.25x10.5in %d") ("^landscape$" "%(o?)yap %dS -paper a4r -s 0 %d") ("." "%(o?)yap %dS %d"))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;; Customization ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(custom-set-variables
 ;; -------- Internationalization --------
 ;; set default language environment:
 '(current-language-environment "UTF-8")
 ;; -------- PS Print Customization --------
 ;; Note that to print program source code, it's optimal to print 2 columns 
 ;; per sheet as landscape and set all font sizes to 7.
 ;; set paper and print styles:
 '(ps-paper-type (quote a4)) ;; Paper type is A4 which is default to Letter.
 '(ps-landscape-mode nil) ;; Print landscape. Default to portrait.
 '(ps-number-of-columns 1) ;; Number of columns to be printed per sheet. Default to 1.
 ;; set header/footer/line styles:
 '(ps-header-lines 1) ;; The header uses 1 line.
 '(ps-print-header-frame nil) ;; don't print the header frame.
 '(ps-footer-lines 1) ;; The footer uses 1 line.
 '(ps-line-number t) ;; The line numbers are to be printed.
 ;; set font sizes:
 '(ps-header-font-size (quote (8 . 8)))
 '(ps-header-title-font-size (quote (8 . 8)))
 '(ps-footer-font-size (quote (8 . 8)))
 '(ps-font-size (quote (8 . 8)))
 '(ps-line-number-font-size 8)
 ;; set font families
 '(ps-header-font-family (quote Courier))
 ;; Set buffer name style:
 '(uniquify-buffer-name-style (quote forward) nil (uniquify))
 ;; undo limits:
 '(undo-limit 80000)
 '(undo-strong-limit 100000)
 ;; large file threshold for emacs 22:
 '(large-file-warning-threshold 268435455) ;; warn if file larger than 256MB.
 )

(custom-set-faces)

;;;;;;;;;;;;;;;;;;;;;;;;;;;; Telnet ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; To run telnet inside Emacs on Windows, you have to
;; 1. use telnet of Cygwin (in inetutils package) and
;; 2. defun telnet with following code.
(if (eq system-type 'windows-nt)
    (progn (require 'telnet)
;    (setq telnet-progrom "C:/programs/cygwin/bin/telnet.exe")
     (defun telnet (host)
       "Open a network login connection to host named HOST (a string).
              Communication with HOST is recorded in a buffer `*PROGRAM-HOST*'
              where PROGRAM is the telnet program being used.  This program
              is controlled by the contents of the global variable
              `telnet-host-properties', falling back on the value of the
              global variable `telnet-program'. Normally input is edited
              in Emacs and sent a line at a time."
       (interactive "sOpen connection to host: ")
       (let* ((comint-delimiter-argument-list '(?\  ?\t))
        (properties (cdr (assoc host telnet-host-properties)))
        (telnet-program (if properties (car properties) telnet-program))
        (name (concat telnet-program "-" (comint-arguments host 0 nil) ))
        (buffer (get-buffer (concat "*" name "*")))
        (telnet-options (if (cdr properties)
          (cons "-l" (cdr properties))))
        process)
         (if (and buffer (get-buffer-process buffer))
       (pop-to-buffer (concat "*" name "*"))
     (pop-to-buffer
      (apply 'make-comint name telnet-program nil telnet-options))
     (setq process (get-buffer-process (current-buffer)))
     ;;(set-process-filter process 'telnet-initial-filter)
     ;; Don't send the `open' cmd till telnet is ready for it.
     ;;(accept-process-output process)
     (erase-buffer)
     (send-string process (concat "open " host "\n"))
     (telnet-mode)
     (setq telnet-remote-echoes nil)
     (setq telnet-new-line "\n") ;; needed for cygwin 1.3.11
     (setq comint-input-sender 'telnet-simple-send)
     (setq telnet-count telnet-initial-count)
     (setq comint-process-echoes t))))
     ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;; Windows App ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(if (eq system-type 'windows-nt)
    (progn
      (require 'dired) ;; to avoid being warned "dired-get-filename unknown".
      (defvar winapp-alist 
  '(("txt" . "C:/bin/emacs/bin/emacsclientw.exe")
    ("xls" . "C:/Program Files/Microsoft Office/OFFICE11/EXCEL.EXE")
    ("pl" . "C:/bin/perl/bin/perl.exe")
    ("ulaw" . "play_ulaw.exe")))
      (defun open-file-with-winapp ()
  "Open a file with an appropriate windows application"
  (interactive)
  (let* ((file (dired-get-filename))
         (app (cdr (assoc (file-name-extension file) winapp-alist)))
         (msg (format "Open %s with %s" file app)))
    (message msg)
    (start-process msg "*Messages*" app file)))
      (add-hook 'dired-mode-hook
    '(lambda () (local-set-key "r" 'open-file-with-winapp)))
      (defun dired-clip-filename ()
  "Clip a file name to the kill ring."
  (interactive)
  (kill-new (dired-get-filename))
  (message (concat "Copied filename: " (current-kill 0))))
      (add-hook 'dired-mode-hook
    '(lambda () (local-set-key "c" 'dired-clip-filename)))
      ))

(if (eq system-type 'gnu/linux)
    (progn
      (require 'dired)
      (defun extract-dfile ()
  "Extract a dfile"
  (interactive)
  (message "dfile %s" (dired-get-filename))
  (start-process "extract-dfile" "*Messages*" "dfile" "extractall" (dired-get-filename)))
      (add-hook 'dired-mode-hook '(lambda () (local-set-key "r" 'extract-dfile)))
      ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Web Beautify ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'web-beautify) ;; Not necessary if using ELPA package
(eval-after-load 'js2-mode
  '(define-key js2-mode-map (kbd "C-c b") 'web-beautify-js))
;; Or if you're using 'js-mode' (a.k.a 'javascript-mode')
(eval-after-load 'js
  '(define-key js-mode-map (kbd "C-c b") 'web-beautify-js))

(eval-after-load 'json-mode
  '(define-key json-mode-map (kbd "C-c b") 'web-beautify-js))

(eval-after-load 'sgml-mode
  '(define-key html-mode-map (kbd "C-c b") 'web-beautify-html))

(eval-after-load 'web-mode
  '(define-key web-mode-map (kbd "C-c b") 'web-beautify-html))

(eval-after-load 'css-mode
  '(define-key css-mode-map (kbd "C-c b") 'web-beautify-css))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;; End of my init file for GNU Emacs ;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
