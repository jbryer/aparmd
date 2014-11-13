#' PDF format for APA documents
#' 
#' @export
apa_document <- function() {
    template <- system.file('rmarkdown/templates/apa_document/resources/template.tex', 
                            package='aparmd')
    base <- rmarkdown::pdf_document(template=template, keep_tex=TRUE)
    
    base$pandoc$to <- "latex"
    base$pandoc$ext <= ".tex"
    
    base$knitr$opts_knit$out.format <- "sweave"
    
    base$knitr$opts_chunk$prompt <- TRUE
    base$knitr$opts_chunk$comment <- NA
    base$knitr$opts_chunk$highlight <- FALSE
    
#     base$post_processor <- function(metadata, utf8_input, output_file, clean, verbose) {
#         dir <- dirname(output_file)
#         filename <- tools::file_path_sans_ext(basename(output_file))
#         tools::texi2pdf(paste0(filename, '.tex'), clean=clean)
#         return(paste0(dir, '/', filename, '.pdf'))
#     }
    
    # TODO: Probably want to use something other than verbatim for code chunks
    hook_chunk <- function(x, options) {
        if(knitr:::output_asis(x, options)) {
            return(x)  
        } else {
            paste0('\\begin{verbatim}\n', x, '\\end{verbatim}')
        }
    }
    hook_input <- function(x, options) {
        paste0(c('\\begin{verbatim}\n', x, '\\end{verbatim}', ''), collapse = '\n')
    }
    hook_output <- function(x, options) {
        paste0('\\begin{verbatim}\n', x, '\\end{verbatim}\n')
    }
    
#     base$knitr$knit_hooks$chunk   <- hook_chunk
#     base$knitr$knit_hooks$source  <- hook_input
#     base$knitr$knit_hooks$output  <- hook_output
#     base$knitr$knit_hooks$message <- hook_output
#     base$knitr$knit_hooks$warning <- hook_output

    base$knitr$knit_hooks$plot <- function(x, options) {
        paste0('\\begin{figure}[htbp]\n\\centering',
               knitr::hook_plot_tex(x, options),
               '\\caption{', options$caption, '}\n',
               '\\label{', options$label, '}\n',
               '\\end{figure}')
    }
    #base$knitr$knit_hooks$plot <- knitr::hook_plot_tex
    
    return(base)
}
