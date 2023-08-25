;;; mainspring-org-prettify.el --- Grants the ability to theme org modes headlines and lists.

;; Copyright (C) 2018 Jonathan Hope

;; Author: Jonathan Hope <jonathan.douglas.hope@gmail.com>
;; Version: 1.0
;; Keywords: org, prettify

;;; Commentary:

;; mainspring-org-prettify grants the user the ability to safely theme headlines and plain
;; lists in org documents. The headlines will be indented headline level characters using
;; mainspring-org-prettify-headline-dash followed by mainspring-org-prettify-headline-bullet.
;; The plain list characters are simply swapped using mainspring-org-prettify-plain-list-plus-char,
;; mainspring-org-prettify-plain-list-asterisk-char, and mainspring-org-prettify-plain-list-minus-char.

;;; Code:

(eval-when-compile (require 'cl))

(defgroup mainspring-org-prettify nil
  "Visual tweaks for org mode."
  :group 'org-appearance)

(defcustom mainspring-org-prettify-headline-dash ?━
  "What character to use for indenting the org headline character."
  :group 'mainspring-org-prettify)

(defcustom mainspring-org-prettify-headline-bullet ?⬢
  "What character to demark a headline with."
  :group 'mainspring-org-prettify)

(defcustom mainspring-org-prettify-plain-list-plus-char ?➤
  "What character to demark a plain list using pluses with."
  :group 'mainspring-org-prettify)

(defcustom mainspring-org-prettify-plain-list-asterisk-char ?➤
  "What character to demark a plain list using asterisks with."
  :group 'mainspring-org-prettify)

(defcustom mainspring-org-prettify-plain-list-minus-char ?➤
  "What character to demark a plain list using minuses with."
  :group 'mainspring-org-prettify)

(defcustom mainspring-org-prettify-todo ?⬜
  "What character to demark a TODO in a headline."
  :group 'mainspring-org-prettify)

(defcustom mainspring-org-prettify-todo-pad nil
  "Whether to add a padding char to the TODO replacement."
  :group 'mainspring-org-prettify)

(defcustom mainspring-org-prettify-done ?⬛
  "What character to demark a DONE in a headline."
  :group 'mainspring-org-prettify)

(defcustom mainspring-org-prettify-done-pad nil
  "Whether to add a padding char to the DONE replacement."
  :group 'mainspring-org-prettify)

(defcustom mainspring-org-prettify-checkbox-unchecked ?⚪
  "What character to demark a unchecked checkbox in a plain list."
  :group 'mainspring-org-prettify)

(defcustom mainspring-org-prettify-checkbox-unchecked-pad nil
  "Whether to add pading to the checked checkbox replacemnet."
  :group 'mainspring-org-prettify)

(defcustom mainspring-org-prettify-checkbox-checked ?⚫
  "What character to demark a checked checkbox in a plain list."
  :group 'mainspring-org-prettify)

(defcustom mainspring-org-prettify-checkbox-checked-pad nil
  "Whether to add pading to the unchecked checkbox replacemnet."
  :group 'mainspring-org-prettify)

(defun mainspring-org-prettify-add-to-list (list-var element)
  "Adds an element to the end of a list."
  (set list-var
	     (append (symbol-value list-var) (list element)) ))

(defun mainspring-org-prettify-get-headline-char (level)
  (let ((headline-char '()))
    (progn
      (dotimes (number level)
        (progn
          (mainspring-org-prettify-add-to-list 'headline-char mainspring-org-prettify-headline-dash)
          (mainspring-org-prettify-add-to-list 'headline-char '(Br . Bl))))
      (mainspring-org-prettify-add-to-list 'headline-char mainspring-org-prettify-headline-bullet))))

(defun mainspring-org-prettify-get-char (replacement pad)
  (let ((char '()))
    (progn
      (mainspring-org-prettify-add-to-list 'char replacement)
      (if pad (mainspring-org-prettify-add-to-list 'char '(Br . Bl)))
      (if pad (mainspring-org-prettify-add-to-list 'char ?\s))
      char)))


(define-minor-mode mainspring-org-prettify-mode
  "Visual tweaks for org mode."
  nil nil nil
  (let* ((headlines
          `(("^\\*+ "
             (0 (let* (( level (- (match-end 0) (match-beginning 0) 1)))
                  (compose-region (- (match-end 0) (+ 2 (- level 1)))
                                  (- (match-end 0) 1)
                                  (mainspring-org-prettify-get-headline-char level))
                  nil)))))

         (todo
          `(("^\\*+ TODO "
             (0 (prog1 () (compose-region
                           (- (match-end 0) 5)
                           (- (match-end 0) 1)
                           (mainspring-org-prettify-get-char
                            mainspring-org-prettify-todo
                            mainspring-org-prettify-todo-pad)))))))

         (done
          `(("^\\*+ DONE "
             (0 (prog1 () (compose-region
                           (- (match-end 0) 5)
                           (- (match-end 0) 1)
                           (mainspring-org-prettify-get-char
                            mainspring-org-prettify-done
                            mainspring-org-prettify-done-pad)))))))

         (plain-list-plus
          `(("^ +\\+ "
             (0
              (prog1 () (compose-region
                         (- (match-end 0) 2)
                         (- (match-end 0) 1)
                         mainspring-org-prettify-plain-list-plus-char))))))

         (plain-list-asterisk
          `(("^ +\\* "
             (0
              (prog1 () (compose-region
                         (- (match-end 0) 2)
                         (- (match-end 0) 1)
                         mainspring-org-prettify-plain-list-asterisk-char))))))

         (plain-list-minus
          `(("^ +\\- "
             (0
              (prog1 () (compose-region
                         (- (match-end 0) 2)
                         (- (match-end 0) 1)
                         mainspring-org-prettify-plain-list-minus-char))))))

         (checkbox-unchecked
          `(("^ +\\(\\-\\|\\+\\|\\*\\|[0-9]+[\\)\\.]\\) \\[ \\] "
             (0
              (prog1 () (compose-region
                         (- (match-end 0) 4)
                         (- (match-end 0) 1)
                         (mainspring-org-prettify-get-char
                          mainspring-org-prettify-checkbox-unchecked
                          mainspring-org-prettify-checkbox-unchecked-pad)))))))

         (checkbox-checked
          `(("^ +\\(\\-\\|\\+\\|\\*\\|[0-9]+[\\)\\.]\\) \\[X\\] "
             (0
              (prog1 () (compose-region
                         (- (match-end 0) 4)
                         (- (match-end 0) 1)
                         (mainspring-org-prettify-get-char
                          mainspring-org-prettify-checkbox-checked
                          mainspring-org-prettify-checkbox-checked-pad))))))))

    (if mainspring-org-prettify-mode
        (progn
          (font-lock-add-keywords nil headlines)
          (font-lock-add-keywords nil todo)
          (font-lock-add-keywords nil done)
          (font-lock-add-keywords nil plain-list-plus)
          (font-lock-add-keywords nil plain-list-asterisk)
          (font-lock-add-keywords nil plain-list-minus)
          (font-lock-add-keywords nil checkbox-unchecked)
          (font-lock-add-keywords nil checkbox-checked)
          (font-lock-fontify-buffer))
      (save-excursion
        (goto-char (point-min))
        (font-lock-remove-keywords nil headlines)
        (font-lock-remove-keywords nil todo)
        (font-lock-remove-keywords nil done)
        (font-lock-remove-keywords nil plain-list-plus)
        (font-lock-remove-keywords nil plain-list-asterisk)
        (font-lock-remove-keywords nil plain-list-minus)
        (font-lock-remove-keywords nil checkbox-unchecked)
        (font-lock-remove-keywords nil checkbox-checked)
        (font-lock-fontify-buffer)))))

(provide 'mainspring-org-prettify)

;;; mainspring-org-prettify.el ends here
