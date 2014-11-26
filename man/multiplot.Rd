\name{multiplot}
\alias{multiplot}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
%%  ~~function to do ... ~~
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
multiplot(..., plotlist = NULL, cols = 1, layout = NULL, widths = NULL, heights = NULL, title = NULL, titlefont = "", titleface = 1, titlesize = 16)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{\dots}{
%%     ~~Describe \code{\dots} here~~
}
  \item{plotlist}{
%%     ~~Describe \code{plotlist} here~~
}
  \item{cols}{
%%     ~~Describe \code{cols} here~~
}
  \item{layout}{
%%     ~~Describe \code{layout} here~~
}
  \item{widths}{
%%     ~~Describe \code{widths} here~~
}
  \item{heights}{
%%     ~~Describe \code{heights} here~~
}
  \item{title}{
%%     ~~Describe \code{title} here~~
}
  \item{titlefont}{
%%     ~~Describe \code{titlefont} here~~
}
  \item{titleface}{
%%     ~~Describe \code{titleface} here~~
}
  \item{titlesize}{
%%     ~~Describe \code{titlesize} here~~
}
}
\details{
%%  ~~ If necessary, more details than the description above ~~
}
\value{
%%  ~Describe the value returned
%%  If it is a LIST, use
%%  \item{comp1 }{Description of 'comp1'}
%%  \item{comp2 }{Description of 'comp2'}
%% ...
}
\references{
%% ~put references to the literature/web site here ~
}
\author{
%%  ~~who you are~~
}
\note{
%%  ~~further notes~~
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
}
\examples{
##---- Should be DIRECTLY executable !! ----
##-- ==>  Define data, use random,
##--	or do  help(data=index)  for the standard data sets.

## The function is currently defined as
function (..., plotlist = NULL, cols = 1, layout = NULL, widths = NULL, 
    heights = NULL, title = NULL, titlefont = "", titleface = 1, 
    titlesize = 16) 
{
    plots <- c(list(...), plotlist)
    numPlots = length(plots)
    if (is.null(layout)) {
        layout <- matrix(seq(1, cols * ceiling(numPlots/cols)), 
            ncol = cols, nrow = ceiling(numPlots/cols))
    }
    if (!is.null(title)) {
        layout <- rbind(rep(0, ncol(layout)), layout)
        if (is.null(heights)) {
            plotrows <- nrow(layout) - 1
            rowheights <- c(0.1, rep(1, plotrows)/plotrows)
        }
        else {
            rowheights <- c(0.1, heights/sum(heights))
        }
    }
    else {
        if (is.null(heights)) {
            rowheights <- rep(1, nrow(layout))
        }
        else {
            rowheights <- heights
        }
    }
    if (is.null(widths)) {
        colwidths <- rep(1, cols)
    }
    else {
        colwidths <- widths
    }
    if (numPlots == 1) {
        return(plots[[1]] + labs(title = title))
    }
    else {
        grid.newpage()
        pushViewport(viewport(layout = grid.layout(nrow(layout), 
            ncol(layout), widths = colwidths, heights = rowheights)))
        for (i in 1:numPlots) {
            matchidx <- as.data.frame(which(layout == i, arr.ind = TRUE))
            print(plots[[i]], vp = viewport(layout.pos.row = matchidx$row, 
                layout.pos.col = matchidx$col))
        }
        if (!is.null(title)) {
            grid.text(title, vp = viewport(layout.pos.row = 1, 
                layout.pos.col = 1:ncol(layout)), gp = gpar(fontfamily = titlefont, 
                fontface = titleface, fontsize = titlesize))
        }
    }
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
