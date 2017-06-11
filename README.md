# aargh

<a href="Pirate Emoji"><img src="https://www.emojirequest.com/images/PirateEmoji.jpg" align="left" height="32" width="32" ></a></br>

Easily Expose R Functions to Command Line Arguments.

This package provides an easy wrapper for automagically converting any R function into a command line driven application. It is inspired by [easyargs](https://pypi.python.org/pypi/easyargs/0.9.3) in Python, and uses the R [argparse](https://cran.r-project.org/web/packages/argparse/index.html) library to access the Python argparse parser.

## Installation

You can install this package directly from github using:

```r
library(devtools)
install_github('jeremystan/aargh')
```

## Usage

For example, consider the simple example app [example.R](/examples/example.R):

```r
library(aargh)

#' Repeat text multiple times, comma delimited
repeat_text <- function(text = 'hi', times = 1L) {
  message <- paste(rep(text, times), collapse = ', ')
  writeLines(message)
}

aargh(repeat_text)
```

Then we can run this app as an `Rscript`:

```
$ Rscript example.R
hi
$ Rscript example.R --times 10
hi, hi, hi, hi, hi, hi, hi, hi, hi, hi
$ Rscript example.R --times 5 --text bye
bye, bye, bye, bye, bye
```

## Functions supported

This only works for functions that:

* Have constant primitive defaults for all arguments (used to infer type)
* Supported types are `numeric`, `integer`, `character` or `logical`

If you want to work with a function that has arguments without defaults, you can simply write a wrapper function that provides a default for those arguments. For example, consider the [sample.R](/examples/sample.R) example:

```r
library(aargh)

#' Wrap the base sample function to specify the size type
wrap_sample <- function(size = 1L) {
  sample(size)
}

aargh(wrap_sample)
```

Then from the command line:

```
$ Rscript sample.R
1
$ Rscript sample.R --size 10
 [1]  8  3  2  7  4  9  1  6 10  5
```

Note that you must use the full syntax `--arg_name` to change an argument.

For logical arguments, you can use syntax like `--flag FALSE` or `--flag F` or `--flag False`, similarly `--flag TRUE`, `--flag T` and `--flag True` all work. But the flag does not work in isolation (e.g., `--flag` will complain it is missing an argument instead of defaulting to `TRUE`).
