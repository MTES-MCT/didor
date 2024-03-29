% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/convert.R
\name{convert}
\alias{convert}
\title{convert}
\usage{
convert(data)
}
\arguments{
\item{data}{a dataframe returned by \code{get_data()}}
}
\value{
a tibble with converted integer and number columns
}
\description{
Try to convert columns according to types sended by the API.
}
\details{
\strong{CAUTION} For private life reason, data returns by DiDo are secretize (the value is
replaced by the string "secret") so readr can't determine data type.

All \code{secret} values will be transform to \code{NA}

You can find column's type with \code{columns()}
}
\examples{
datafiles() \%>\%
  dido_search("6c79805c-def9-4695-9d9f-7d86599c4d8a") \%>\%
  get_data() \%>\%
  convert()
}
