library(aargh)

#' Wrap the base sample function to specify the size type
wrap_sample <- function(size = 1L) {
  sample(size)
}

aargh(wrap_sample)
