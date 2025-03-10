test_that("prep_pred() returns what it should", {
  p <- prep_pred(1:10)
  expect_equal(p, 1:10)
  expect_true(is.double(p))

  expect_equal(prep_pred(1:10, trafo = log), log(1:10))

  p <- prep_pred(c(TRUE, FALSE))
  expect_equal(p, c(1, 0))
  expect_true(is.double(p))

  expect_equal(prep_pred(data.frame(a = 1:10)), 1:10)
  expect_equal(prep_pred(data.frame(a = 1:10, b = 10:1)), 10:1)

  expect_equal(prep_pred(cbind(a = 1:10)), 1:10)

  x <- cbind(a = 1:10, b = 10:1)
  for (X in list(x, data.frame(x))) {
    expect_equal(prep_pred(X), 10:1)
    expect_equal(prep_pred(X, which_pred = "b"), 10:1)

    expect_equal(prep_pred(X, which_pred = 1), 1:10)
    expect_equal(prep_pred(X, which_pred = "a"), 1:10)
  }
})

test_that("basic_check() works", {
  nms <- letters[1:3]
  n <- 10

  # NULL is ok
  expect_true(basic_check(NULL, n = n, nms = nms))

  # Vector of right length is ok
  expect_true(basic_check(1:10, n = n, nms = nms))
  expect_false(basic_check(1:8, n = n, nms = nms))
  expect_false(basic_check(cbind(1:10), n = n, nms = nms))

  # Variable name is ok
  expect_true(basic_check("a", n = n, nms = nms))
  expect_false(basic_check("a", n = n, nms = letters[4:6]))
})

test_that(".subsample() works", {
  n <- 5
  X <- matrix(1:(2 * n), ncol = 2)
  w <- 1:n
  expect_equal(.subsample(X, n + 1, w = w), list(X = X, w = w))

  subs <- .subsample(X, nmax = 1)
  expect_true(nrow(subs$X) == 1)
  expect_null(subs$w)
  expect_true(length(subs$ix) == 1)
})

test_that("check_v_type() works", {
  mat <- list(
    int = cbind(1:10),
    double = cbind(pi),
    logical = cbind(c(TRUE, FALSE)),
    char = cbind(LETTERS[1:10])
  )
  for (x in mat) {
    expect_true(check_v_type(x))
  }
  expect_false(check_v_type(as.Date("2024-08-01")))
})

test_that("feature_effects() tolerates missing y when weights are non-positive", {
  X = cbind(a = 1:4, b = 2:5)
  suppressMessages(
    eff <- feature_effects(
      NULL,
      v = "a",
      y = c(NA, NA, 1, 2),
      w = c(0, NA, 1, 1),
      data = X,
      calc_pred = FALSE,
      pd_n = 0,
      ale_n = 0,
      breaks = c(0, 4),
      discrete_m = 1
    )
  )
  expect_equal(eff$a$y_mean, 1.5)

  # NA in y is not allowed when weights are positive
  expect_error(
    feature_effects(
      NULL,
      v = "a",
      y = c(NA, NA, 1, 2),
      w = c(1, 1, 1, 1),
      data = X,
      calc_pred = FALSE,
      pd_n = 0,
      ale_n = 0
    )
  )
})
