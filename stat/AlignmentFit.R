require(pwr)

args <- commandArgs(TRUE)
file<-args[1]

if(!file.exists(file)) {
  stop("Please provide valid input file.")
}

assessSignificance <- function(case){ 
  warning(case)
  stopifnot(case>=5)
  df<-(length(case)-1)
  sample_size<-sum(case)
  
  alpha<-0.0000000001 #default alpha value
  tryCatch(
        #Calculating alpha value for fixed power
        alpha<-pwr.chisq.test(w=0.3,df=df,N=sample_size,power=0.8,sig.level=NULL)$sig.level
        ,
        # But if an error occurs, we will stick to the default alpha value. 
        # This happens when the alpha value becomes extremely small.
        error=function(error_message) {
            message("Uniroot problem: alpha will remain at the minimum value of 0.0000000001.")
            message(error_message)
          }
    )

  pvalue<-chisq.test(case)$p.value
  write(paste("alpha:",alpha,"pvalue:",pvalue,"df:",df,"sample_size:",sample_size), stderr())
  if (pvalue<=alpha) {
    write("Reject null, our positions are biased.", stderr())
    write("1", stdout())
  } else {
    write("All positions have equal number of errors.", stderr())
    write("0", stdout())
  }
}

alignmentMatrix<-read.table(file, header=TRUE, sep="\t")
assessSignificance(alignmentMatrix$E)
