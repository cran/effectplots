% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/update.R
\name{update.EffectData}
\alias{update.EffectData}
\title{Update "EffectData" Object}
\usage{
\method{update}{EffectData}(
  object,
  sort_by = c("no", "pd", "pred_mean", "y_mean", "resid_mean", "ale"),
  to_factor = FALSE,
  collapse_m = 15L,
  collapse_by = c("weight", "N"),
  drop_empty = FALSE,
  drop_below_n = 0,
  drop_below_weight = 0,
  na.rm = FALSE,
  ...
)
}
\arguments{
\item{object}{Object of class "EffectData".}

\item{sort_by}{By which statistic ("pd", "pred_mean", "y_mean", "resid_mean", "ale")
should the results be sorted? The default is "no" (no sorting). Calculated
after all other update steps, e.g., after collapsing or dropping rare levels.}

\item{to_factor}{Should discrete features be treated as factors?
In combination with \code{collapse_m}, this can be used to collapse rare values of
discrete numeric features.}

\item{collapse_m}{If a factor or character feature has more than \code{collapse_m} levels,
rare levels are collapsed into a new level "other p". Standard deviations are
collapsed via root of the weighted average variances. The default is 15.
Set to \code{Inf} for no collapsing.}

\item{collapse_by}{How to determine "rare" levels in \code{collapse_m}?
Either "weight" (default) or "N". Only matters in situations with case weights \code{w}.}

\item{drop_empty}{Drop empty bins. Equivalent to \code{drop_below_n = 1}.
The default is \code{FALSE}.}

\item{drop_below_n}{Drop bins with N below this value. Applied after collapsing.
The default is 0.}

\item{drop_below_weight}{Drop bins with weight below this value. Applied after
collapsing. The default is 0.}

\item{na.rm}{Should missing bin centers be dropped? Default is \code{FALSE}.}

\item{...}{Currently not used.}
}
\value{
A modified object of class "EffectData".
}
\description{
Updates an "EffectData" object by
\itemize{
\item turning discrete values to factor (especially useful with the next option),
\item collapsing levels of categorical variables with many levels,
\item dropping empty bins,
\item dropping small bins,
\item dropping bins with missing name, or
\item sorting the variables by their importance, see \code{\link[=effect_importance]{effect_importance()}}-
}

Except for \code{sort_by}, all arguments are vectorized, i.e., you can
pass a vector or list of the same length as \code{object}.
}
\examples{
fit <- lm(Sepal.Length ~ ., data = iris)
xvars <- colnames(iris)[-1]
feature_effects(fit, v = xvars, data = iris, y = "Sepal.Length", breaks = 5) |>
  update(sort = "pd", collapse_m = 2) |>
  plot()
}
\seealso{
\code{\link[=feature_effects]{feature_effects()}}, \code{\link[=average_observed]{average_observed()}}, \code{\link[=average_predicted]{average_predicted()}},
\code{\link[=partial_dependence]{partial_dependence()}}, \code{\link[=ale]{ale()}}, \code{\link[=bias]{bias()}}, \code{\link[=effect_importance]{effect_importance()}}
}
