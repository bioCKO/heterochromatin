#/galaxy/home/biomonika/R-3.2.4revised/bin/Rscript generateErrorStatistics.R motifFile pathTocmpFile

library("h5r", lib.loc = "/galaxy/home/biomonika/R-3.2.4revised_nn/library/")
library("pbh5", lib.loc = "/galaxy/home/biomonika/R-3.2.4revised_nn/lib")
library("data.table", lib.loc = "/galaxy/home/biomonika/R-3.2.4revised_nn/lib")
options(show.error.locations = TRUE)

args <- commandArgs(trailingOnly = TRUE)
pathTocmpFile = args[1]
reference = args[2]
folder = args[3]

setwd(args[4])

cmpH5file = paste(pathTocmpFile, "chr", reference, "_P6.cmp.h5", sep = "")
cmp = PacBioCmpH5(cmpH5file)

##get IPDs by template position
res = getByTemplatePosition(cmp, f = getIPD)
RES <- as.data.table(res)
setkey(RES, "position", "read", "ref")


getWindow <- function(arguments) {
  #print(arguments)
  chr <- arguments[1]
  start <- as.numeric(arguments[2])
  end <- as.numeric(arguments[3])
  
  rates <- (getErrorRate(start, end))
  percErrorTotal <- (rates[[2]] + rates[[3]] + rates[[4]]) / rates[[1]] *
    100
  percErrorIns <- (rates[[2]]) / rates[[1]] * 100
  percErrorDel <- (rates[[3]]) / rates[[1]] * 100
  percErrorMism <- (rates[[4]]) / rates[[1]] * 100
  
  return(
    paste(
      reference,
      start,
      end,
      rates[[1]],
      rates[[2]],
      rates[[3]],
      rates[[4]],
      percErrorTotal,
      percErrorIns,
      percErrorDel,
      percErrorMism,
      paste0("$", rates[[5]], "$", rates[[6]]),
      sep = " "
    )
  )
  #rows<-rbind(rows,t)
  #write.table(t, file=filename, col.names = FALSE,row.names = FALSE,quote=FALSE,sep="\t",append=TRUE)
  
}

getErrorRate <- function(start, end) {
  # start
  # end
  w <-
    RES[position >= start &
          position < end] #cut out relevant portion from the data
  dim(w)
  if (nrow(w) > 0) {
    totalRows <- nrow(w)
    
    insertion_lengths <-
      unlist(lapply(unique(w$idx), function(x)
        (rle(w[idx == x]$ref)$lengths[rle(w[idx == x]$ref)$values == "-"])))
    if (!length(insertion_lengths) > 0) {
      insertion_lengths <- NA
    }
    
    deletion_lengths <-
      unlist(lapply(unique(w$idx), function(x)
        (rle(w[idx == x]$read)$lengths[rle(w[idx == x]$read)$values == "-"])))
    if (!length(deletion_lengths) > 0) {
      deletion_lengths <- NA
    }
    
    insertionRows <- nrow(w[as.character(w$ref) == "-", ])
    deletionRows <- nrow(w[as.character(w$read) == "-", ])
    mismatchRows <-
      nrow(w[as.character(w$ref) != as.character(w$read) &
               (as.character(w$ref) != "-") & (as.character(w$read) != "-"), ])
    
    return(list(
      totalRows,
      insertionRows,
      deletionRows,
      mismatchRows,
      list(as.numeric(insertion_lengths)),
      list(as.numeric(deletion_lengths))
    ))
  }
}

processMotif <- function(motif) {
  print("ITERATION")
  print(reference)
  print(motif)
  
  filename <-
    paste(reference,
          ".ERRORS",
          folder,
          ".",
          basename(motif),
          ".txt",
          sep = "")
  motifFile <- paste(folder, "/", motif, sep = "")
  
  if (file.exists(motifFile)) {
    #.mf file exists
    coordinates <-
      read.table(motifFile,col.names = paste0("V",seq_len(max(count.fields(motifFile)))), fill = TRUE)[, 1:3] #read only first three columns
    coordinates <- as.data.table(coordinates)
    setkey(coordinates, "V1", "V2", "V3")
    print(dim(coordinates))
    coordinates <-
      subset(coordinates, V1 == reference) #subset only to specific chromosome #paste("chr",reference,sep="")
    print(dim(coordinates))
    
    #rows<-NULL
    rows <- apply(coordinates, 1, function(x)
      getWindow(x))

    if (file.exists(filename)) {
      file.remove(filename) #file with results already exists, remove before writing
    }

    system.time(
      write.table(
        as.matrix(rows),
        file = filename,
        col.names = FALSE,
        row.names = FALSE,
        quote = FALSE,
        sep = "\t",
        append = TRUE
      )
    )
  } else {
    print("File does not exist, skipping.")
  }
}

listMotifs <-
  c("APhasedRepeatsFeatureOnly.mf",
    "DirectRepeatsFeatureOnly.mf",
    "EmptyFeatureOnly.mf",
    "GQuadMinusFeatureOnly.mf",
    "GQuadPlusFeatureOnly.mf",
    "InvertedRepeatsFeatureOnly.mf",
    "MirrorRepeatsFeatureOnly.mf",
    "ZDNAMotifsFeatureOnly.mf"
  )
listEmpty <-
  c("APhasedRepeatsFeatureOnly.mfEmptyTmp",
    "DirectRepeatsFeatureOnly.mfEmptyTmp",
    "EmptyFeatureOnly.mfEmptyTmp",
    "GQuadMinusFeatureOnly.mfEmptyTmp",
    "GQuadPlusFeatureOnly.mfEmptyTmp",
    "InvertedRepeatsFeatureOnly.mfEmptyTmp",
    "MirrorRepeatsFeatureOnly.mfEmptyTmp",
    "ZDNAMotifsFeatureOnly.mfEmptyTmp"
  )


list <- c(listMotifs, listEmpty)

library(parallel)

# Calculate the number of cores
no_cores <- 8
# Initiate cluster
cl <- makeCluster(no_cores, type = "FORK")

print("PARALLEL")
ptm <- proc.time()
parLapply(cl, list,
          function(motif)
            processMotif(motif))
stopCluster(cl)
proc.time() - ptm


print("Done.")
traceback()