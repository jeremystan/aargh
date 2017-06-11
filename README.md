# aargh

Easily Expose R Functions to Command Line Arguments.

This is an experimental package meant to provide a very easy wrapper for automagically converting any R function into a command line driven application. It is inspired by easyargs and python-fire in Python, and uses the R argparse library to access the Python argparse parser. ADD LINKS

## Usage

Example `test.R` app:

```r
library(aargh)

f <- function(x = 0.1, i = 1L, t = "text", l = TRUE) {
  writeLines(sprintf("x: %s, class %s", x, class(x)))
  writeLines(sprintf("i: %s, class %s", i, class(i)))
  writeLines(sprintf("t: %s, class %s", t, class(t)))
  writeLines(sprintf("l: %s, class %s", l, class(l)))
}

aargh(f)
```

Then from the command line you will see:

```
$ Rscript test.R --x 0.3 --t gotcha
Loading aargh
x: 0.3, class numeric
i: 1, class integer
t: gotcha, class character
l: TRUE, class logical
```

## Limitations

This only works for functions that:

* Have constant defaults for all arguments (used to infer type)
* All arguments are of type `numeric`, `integer`, `character` or `logical`

Note that you have to use the full syntax `--arg_name` to change an argument

For logical arguments, you can use syntax like `--l FALSE` or `--l F` or `--l False`, similarly `--l TRUE`, `--l T` and `--l True` all work. But the flag does not work in isolation (e.g., `--l` will complain it is missing an argument instead of defaulting to `TRUE`).
