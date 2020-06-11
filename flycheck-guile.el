;;; flycheck-guile.el --- A Flycheck checker for GNU Guile -*- lexical-binding: t -*-

;; Copyright (C) 2019  Ricardo Wurmus <rekado@elephly.net>
;; Copyright (C) 2020  Free Software Foundation, Inc

;; Author: Ricardo Wurmus <rekado@elephly.net>
;; Maintainer: Andrew Whatson <whatson@gmail.com>
;; Version: 0.1
;; URL: https://github.com/flatwhatson/flycheck-guile
;; Package-Requires: ((emacs "24.1") (flycheck "0.22") (geiser "0.11"))

;; This file is not part of GNU Emacs.

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; GNU Guile syntax checking support for Flycheck.

;;; Code:

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

(provide 'flycheck-guile)
;;; flycheck-guile.el ends here
