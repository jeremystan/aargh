library(devtools)
load_all(quiet = TRUE)

f <- function(x = 0.1, i = 1L, t = "text", l = TRUE) {
  writeLines(sprintf("x: %s, class %s", x, class(x)))
  writeLines(sprintf("i: %s, class %s", i, class(i)))
  writeLines(sprintf("t: %s, class %s", t, class(t)))
  writeLines(sprintf("l: %s, class %s", l, class(l)))
}

aargh(f)
