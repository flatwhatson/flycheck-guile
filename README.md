[![Melpa Status](http://melpa.org/packages/flycheck-guile-badge.svg)](http://melpa.org/#/flycheck-guile)
[![Melpa Stable Status](http://stable.melpa.org/packages/flycheck-guile-badge.svg)](http://stable.melpa.org/#/flycheck-guile)
[![GNU Guix Status](https://repology.org/badge/version-for-repo/gnuguix/emacs:flycheck-guile.svg?header=GNU%20Guix)](https://repology.org/project/emacs:flycheck-guile/versions)

# flycheck-guile

This library provides a [flycheck][] checker for the [GNU Guile][guile]
programming language.  It requires a working [Geiser][geiser] configuration, and
runs `guild compile` on your code to collect warnings and errors.

## Installation

### MELPA

This package is available on [MELPA][melpa].

After following MELPA's [Getting Started][melpa-getting-started] guide, you can
install this package with `M-x package-install flycheck-guile`.

### Guix

This package is available on [Guix][guix].

It can be installed to your user profile with `guix install
emacs-flycheck-guile`.

### Manual installation

To install it manually, just download this code add the directory to your Emacs
`load-path`.

## Usage

Call `(require 'flycheck-guile)` somewhere in your Emacs configuration to load
the checker.

Once loaded, the checker will automatically activate in `scheme-mode` buffers
with `geiser-mode`, where `guile` is the current scheme implementation.

## Configuration

This package can be configured via `M-x customize-group flycheck-guile`.

The `flycheck-guile-warnings` variable contains the list of warnings reported by
the compiler.  If you find a warning particularly annoying (eg. spurious "unused
variable" warnings), it can be suppressed by removing it from this list.

The `flycheck-guile-args` variable contains a list of additional arguments to be
passed to `guild compile`.  This can be useful to pass an `--r6rs` or `--r7rs`
argument argument when working with standard Scheme.

## Troubleshooting

If it seems like the checker is not working, try running `M-x
flycheck-verify-checker guile` for some diagnostics.

It may also be useful to run `M-x flycheck-compile guile`, which shows the full
compilation command and its output.

If the checker is working, but can't find your guile modules (ie. reporting "no
code for module" errors), make sure that you have correctly configured
`geiser-guile-load-path` for your project.  The checker uses this variable to
determine the load paths passed to `guild compile`.

A simple way to configure load paths is to add a `.dir-locals.el` file to the
root directory of the project:

``` emacs-lisp
((nil
  (eval . (with-eval-after-load 'geiser-guile
            (let ((root-dir
                   (file-name-directory
                    (locate-dominating-file default-directory ".dir-locals.el"))))
              (make-local-variable 'geiser-guile-load-path)
              (add-to-list 'geiser-guile-load-path root-dir))))
  ))
```

This will look for the Guile module `(foo bar baz)` in `foo/bar/baz.scm`
relative to the root directory of the project.

## License

This program is free software: you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free Software
Foundation, either version 3 of the License, or (at your option) any later
version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with
this program.  If not, see <http://www.gnu.org/licenses/>.

See [COPYING](COPYING) for details.

## Credits

`flycheck-guile` was originally written by Ricardo Wurmus as part of [Guile
Studio][guile-studio].

[flycheck]: https://github.com/flycheck/flycheck
[geiser]: https://www.nongnu.org/geiser/
[guile]: https://www.gnu.org/software/guile/guile.html
[guile-studio]: https://git.elephly.net/software/guile-studio.git
[guix]: https://guix.gnu.org/
[melpa]: http://melpa.org/
[melpa-getting-started]: https://melpa.org/#/getting-started
