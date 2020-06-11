;; Check syntax on the fly
(require 'flycheck)
(flycheck-define-checker guile
  "A Guile syntax checker with `guild compile'."
  :command ("guild" "compile" "--to=cps"
            "--warn=unused-variable"
            "--warn=unused-toplevel"
            "--warn=unbound-variable"
            "--warn=macro-use-before-definition"
            "--warn=arity-mismatch"
            "--warn=duplicate-case-datum"
            "--warn=bad-case-datum"
            "--warn=format"
            source)
  :predicate
  (lambda ()
    (and (boundp 'geiser-impl--implementation)
         (eq geiser-impl--implementation 'guile)))
  :verify
  (lambda (checker)
    (let ((geiser-impl (bound-and-true-p geiser-impl--implementation)))
      (list
       (flycheck-verification-result-new
        :label "Geiser Implementation"
        :message (cond
                  ((eq geiser-impl 'guile) "Guile")
                  (geiser-impl (format "Other: %s" geiser-impl))
                  (t "Geiser not active"))
        :face (cond
               ((or (eq geiser-impl 'guile)) 'success)
               (t '(bold error)))))))
  :error-patterns
  ((warning
    line-start (file-name) ":" line ":" column ": warning:" (message) line-end)
   (error
    line-start (file-name) ":" line ":" column ":" (message) line-end))
  :modes (scheme-mode geiser-mode))
(add-to-list 'flycheck-checkers 'guile)
