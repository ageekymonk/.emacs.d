;; Turquiose
(defun color-theme-turquiose ()
  (interactive)
  (color-theme-install
   '(color-theme-turquiose
     ((background-color . "#000407")
      (foreground-color . "#ddfffc")
      (background-mode . dark)
      (border-color . "#052e2d")
      (cursor-color . "#0d6d6c")
      (mouse-color . "#323232"))
     (powerline-color1 (t("#0d6d6c")))
     (powerline-color2 (t("#001f15")))
     (fringe ((t (:background "#052e2d"))))
     (mode-line ((t (:foreground "#9cf6f4" :background "#0b2c2d"))))
     (region ((t (:background "#0c5f59"))))
     (font-lock-builtin-face ((t (:foreground "#0b8e87"))))
     (font-lock-comment-face ((t (:foreground "#265f59"))))
     (font-lock-function-name-face ((t (:foreground "#60c3be"))))
     (font-lock-keyword-face ((t (:foreground "#0abda7"))))
     (font-lock-string-face ((t (:foreground "#aaedee"))))
     (font-lock-type-face ((t (:foreground"#1f8e8a"))))
     (font-lock-constant-face ((t (:foreground "#1ae9d7"))))
     (font-lock-variable-name-face ((t (:foreground "#0ebeb8"))))
     (minibuffer-prompt ((t (:foreground "#00faf2" :bold t))))
     (font-lock-warning-face ((t (:foreground "red" :bold t)))))))

(provide 'color-theme-turquiose)



