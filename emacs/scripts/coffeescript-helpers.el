;;; coffeescript-helpers.el --- Helpers and misc for coffeescript
;;; Commentary:
;;; Code:

(defun coffee-chomp (str)
  "Chomp leading and tailing whitespace from STR."
  (while (string-match "\\`\n+\\|^\\s-+\\|\\s-+$\\|\n+\\'"
                       str)
    (setq str (replace-match "" t t str)))
  str)


(defun coffee-nav-end-of-block ()
  "Move point to the end of the block."
  (interactive)
  (let ((beg-block-indent)
        (beg-pos (point))
        (last-indentation)
        (current-line))
    (back-to-indentation)
    (setq beg-block-indent (current-indentation))
    ;; assume the next line would be deeper indented
    (setq last-indentation (+ tab-width (current-indentation)))

    (while (progn
             (forward-line)
             (setq current-line (coffee-chomp (thing-at-point 'line)))
             (back-to-indentation)
             ;; Empty strings would have a current-indentation less than the previous line
             ;; so we treat them with the indentation level of the previous line
             (unless (string= "" current-line)
               (setq last-indentation (current-indentation)))
             (end-of-line)

             ;; (message "line %s" (thing-at-point 'line))
             ;; (message "%s" last-indentation)
             ;; (message "%s" beg-block-indent)

             (and (> last-indentation beg-block-indent)
                  (not (eobp)))))

    (forward-line -1)
    (search-backward-regexp ".")
    (end-of-line)))

(provide 'coffeescript-helpers)
;;; coffeescript-helpers.el ends here
