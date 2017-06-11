library(aargh)

#' Repeat text multiple times, comma delimited
repeat_text <- function(text = 'hi', times = 1L) {
  message <- paste(rep(text, times), collapse = ', ')
  writeLines(message)
}

aargh(repeat_text)
