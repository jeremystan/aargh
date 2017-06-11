#' Wraps a function for command line use
#'
#' @param f the function to wrap
#' @export
aargh <- function(f) {

  # Get the required arguments for f
  f_args <- formals(f)

  # Get all command args data
  args_data <- lapply(seq_along(f_args),
                      function(i) argparse_data_from_formal(f_args[i]))

  # Build the argparse parser
  parser <- ArgumentParser()
  for (i in seq_along(args_data)) {
    arg <- args_data[[i]]
    if (arg$type != "logical") {
      parser$add_argument(
        paste0("--", arg$name), type = arg$type, default = arg$default)
    } else {
      # For logical, read in as character and then convert later
      parser$add_argument(
        paste0("--", arg$name), type = "character",
        default = as.character(arg$default))
    }
  }

  # Get the args
  args <- parser$parse_args()

  # Convert any integers (they get converted to numeric in the parser)
  for (i in seq_along(args)) {
    nm <- args_data[[i]]$name
    type <- args_data[[i]]$type
    if (type == "integer")
      args[nm] <- as.integer(args[nm])
    if (type == "logical")
      args[nm] <- as.logical(args[nm])
  }

  # Execute f
  do.call(f, args)
}

#' Interrogates a formal to get argparse data
#'
#' @param x a formal of a function
argparse_data_from_formal <- function(x) {

  if (length(x) > 1)
    stop(sprintf("formal has length %s which is longer than 1", length(x)))

  this_class <- class(x[[1]])
  this_name <- names(x)

  # Check class
  allow_classes <- list(
    "numeric" = "double",
    "integer" = "integer",
    "character" = "character",
    "logical" = "logical")
  if (this_class == "name") {
    stop(sprintf("Argument %s does not have a default value", this_name))
  }
  if (!(this_class %in% names(allow_classes))) {
    msg <- sprintf("Argument %s is of class %s, only constants of type %s are allowed",
                   this_name, this_class,
                   paste(allow_classes, collapse = ", "))
    stop(msg)
  }

  # Get the default value
  this_default <- eval(x[[1]])

  if (is.na(this_default)) {
    stop(sprintf("Argument %s is NA, a default must be specified", this_name))
  }

  list(
    name = this_name,
    type = allow_classes[[this_class]],
    default = this_default
  )

}
