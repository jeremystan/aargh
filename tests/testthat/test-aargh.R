context("bad functions")

test_that("throws an error if an argument doesn't have a default", {

  expect_error(
    aargh(function(x) x),
    "Argument x does not have a default value")

})

test_that("throws an error if an argument has an NA type", {

  expect_error(
    aargh(function(x = NA) x),
    "Argument x is NA, a default must be specified")

})

test_that("throws an error if an argument is a call", {

  expect_error(
    aargh(function(x = factor(1)) x),
    "Argument x is of class call, only constants of type double, integer, character, logical are allowed")

})

test_that("thrwos an error if an argument is a vector", {

  expect_error(
    aargh(function(x = 1:2) x),
    "Argument x is of class call, only constants of type double, integer, character, logical are allowed")

})

context("command line arguments")

test_that("default behavior is as expected", {

  cmd <- 'Rscript ../test_apps/test.R'
  output <- system(cmd, intern = TRUE)
  expected <- (
'x: 0.1, class numeric
i: 1, class integer
t: text, class character
l: TRUE, class logical')
  expect_identical(paste(output, collapse = '\n'),
                   expected)

})

test_that("can change all defaults", {

  cmd <- 'Rscript ../test_apps/test.R --x 0.2 --i 2 --t change --l FALSE'
  output <- system(cmd, intern = TRUE)
  expected <- (
'x: 0.2, class numeric
i: 2, class integer
t: change, class character
l: FALSE, class logical')
  expect_identical(paste(output, collapse = '\n'),
                   expected)

})

test_that("other True / False formats work", {

  cmd <- 'Rscript ../test_apps/test.R --x 0.2 --i 2 --t change --l F'
  output <- system(cmd, intern = TRUE)
  expected <- (
'x: 0.2, class numeric
i: 2, class integer
t: change, class character
l: FALSE, class logical')
  expect_identical(paste(output, collapse = '\n'),
                   expected)

  cmd <- 'Rscript ../test_apps/test.R --x 0.2 --i 2 --t change --l False'
  output <- system(cmd, intern = TRUE)
  expected <- (
'x: 0.2, class numeric
i: 2, class integer
t: change, class character
l: FALSE, class logical')
  expect_identical(paste(output, collapse = '\n'),
                   expected)


})

test_that("invalid types throw error", {

  cmd <- 'Rscript ../test_apps/test.R --x a'
expect_warning(system(cmd, intern = TRUE, ignore.stderr = TRUE))

  cmd <- 'Rscript ../test_apps/test.R --x a 2>&1'
  output <- suppressWarnings(system(cmd, intern = TRUE))
  expected <- (
'usage: ../test_apps/test.R [-h] [--x X] [--i I] [--t T] [--l L]
../test_apps/test.R: error: argument --x: invalid float value: \'a\'')
  expect_identical(paste(output, collapse = '\n'),
                   expected)

})

test_that("value must be specific", {

  cmd <- 'Rscript ../test_apps/test.R --x'
  expect_warning(system(cmd, intern = TRUE, ignore.stderr = TRUE))

  cmd <- 'Rscript ../test_apps/test.R --x 2>&1'
  output <- suppressWarnings(system(cmd, intern = TRUE))
  expected <- (
'usage: ../test_apps/test.R [-h] [--x X] [--i I] [--t T] [--l L]
../test_apps/test.R: error: argument --x: expected one argument')
  expect_identical(paste(output, collapse = '\n'),
                   expected)

})
