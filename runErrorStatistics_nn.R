#/galaxy/home/biomonika/R-3.2.4revised/bin/Rscript generateErrorStatistics.R motifFile pathTocmpFile

library("h5r", lib.loc = "/galaxy/home/biomonika/R-3.2.4revised_nn/library/")
library("pbh5", lib.loc = "/galaxy/home/biomonika/R-3.2.4revised_nn/lib")
library("data.table", lib.loc = "/galaxy/home/biomonika/R-3.2.4revised_nn/lib")
options(show.error.locations = TRUE)

setwd("/nfs/brubeck.bx.psu.edu/scratch6/monika/pac_errors/latest")
args <- commandArgs(trailingOnly = TRUE)
pathTocmpFile = args[1]
reference = args[2]
folder = args[3]

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
      "$",
      rates[[5]],
      "$",
      rates[[6]],
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
      list(insertion_lengths),
      list(deletion_lengths)
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
      read.table(motifFile)[, 1:3] #read only first three columns
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
  c(
    "AAACn.mf",
    "AAAGn.mf",
    "AAATn.mf",
    "AACCn.mf",
    "AACGn.mf",
    "AACn.mf",
    "AACTn.mf",
    "AAGCn.mf",
    "AAGGn.mf",
    "AAGn.mf",
    "AAGTn.mf",
    "AATCn.mf",
    "AATGn.mf",
    "AATn.mf",
    "AATTn.mf",
    "ACAGn.mf",
    "ACATn.mf",
    "ACCCn.mf",
    "ACCGn.mf",
    "ACCn.mf",
    "ACCTn.mf",
    "ACGGn.mf",
    "ACGn.mf",
    "ACn.mf",
    "ACTCn.mf",
    "ACTGn.mf",
    "ACTn.mf",
    "ACTTn.mf",
    "AGATn.mf",
    "AGCCn.mf",
    "AGCGn.mf",
    "AGCn.mf",
    "AGCTn.mf",
    "AGGCn.mf",
    "AGGGn.mf",
    "AGGn.mf",
    "AGGTn.mf",
    "AGn.mf",
    "AGTCn.mf",
    "AGTGn.mf",
    "AGTn.mf",
    "AGTTn.mf",
    "An.mf",
    "APhasedRepeats.mf",
    "ATCCn.mf",
    "ATCn.mf",
    "ATCTn.mf",
    "ATGCn.mf",
    "ATGGn.mf",
    "ATGn.mf",
    "ATGTn.mf",
    "ATn.mf",
    "ATTCn.mf",
    "ATTGn.mf",
    "ATTn.mf",
    "ATTTn.mf",
    "CCCGn.mf",
    "CCCTn.mf",
    "CCGGn.mf",
    "CCGn.mf",
    "CCGTn.mf",
    "CCTGn.mf",
    "CCTn.mf",
    "CCTTn.mf",
    "CGCTn.mf",
    "CGGGn.mf",
    "CGGn.mf",
    "CGGTn.mf",
    "CGn.mf",
    "CGTn.mf",
    "CGTTn.mf",
    "Cn.mf",
    "CTGGn.mf",
    "CTGn.mf",
    "CTGTn.mf",
    "CTn.mf",
    "CTTGn.mf",
    "CTTn.mf",
    "CTTTn.mf",
    "DirectRepeats.mf",
    "Empty.mf",
    "GGGTn.mf",
    "GGTn.mf",
    "GGTTn.mf",
    "Gn.mf",
    "GQuadMinus.mf",
    "GQuadPlus.mf",
    "GTn.mf",
    "GTTn.mf",
    "GTTTn.mf",
    "InvertedRepeats.mf",
    "MirrorRepeats.mf",
    "Tn.mf",
    "ZDNAMotifs.mf"
  )
listEmpty <-
  c(
    "AAACn.mfEmptyTmp",
    "AAAGn.mfEmptyTmp",
    "AAATn.mfEmptyTmp",
    "AACCn.mfEmptyTmp",
    "AACGn.mfEmptyTmp",
    "AACn.mfEmptyTmp",
    "AACTn.mfEmptyTmp",
    "AAGCn.mfEmptyTmp",
    "AAGGn.mfEmptyTmp",
    "AAGn.mfEmptyTmp",
    "AAGTn.mfEmptyTmp",
    "AATCn.mfEmptyTmp",
    "AATGn.mfEmptyTmp",
    "AATn.mfEmptyTmp",
    "AATTn.mfEmptyTmp",
    "ACAGn.mfEmptyTmp",
    "ACATn.mfEmptyTmp",
    "ACCCn.mfEmptyTmp",
    "ACCGn.mfEmptyTmp",
    "ACCn.mfEmptyTmp",
    "ACCTn.mfEmptyTmp",
    "ACGGn.mfEmptyTmp",
    "ACGn.mfEmptyTmp",
    "ACn.mfEmptyTmp",
    "ACTCn.mfEmptyTmp",
    "ACTGn.mfEmptyTmp",
    "ACTn.mfEmptyTmp",
    "ACTTn.mfEmptyTmp",
    "AGATn.mfEmptyTmp",
    "AGCCn.mfEmptyTmp",
    "AGCGn.mfEmptyTmp",
    "AGCn.mfEmptyTmp",
    "AGCTn.mfEmptyTmp",
    "AGGCn.mfEmptyTmp",
    "AGGGn.mfEmptyTmp",
    "AGGn.mfEmptyTmp",
    "AGGTn.mfEmptyTmp",
    "AGn.mfEmptyTmp",
    "AGTCn.mfEmptyTmp",
    "AGTGn.mfEmptyTmp",
    "AGTn.mfEmptyTmp",
    "AGTTn.mfEmptyTmp",
    "An.mfEmptyTmp",
    "APhasedRepeats.mfEmptyTmp",
    "ATCCn.mfEmptyTmp",
    "ATCn.mfEmptyTmp",
    "ATCTn.mfEmptyTmp",
    "ATGCn.mfEmptyTmp",
    "ATGGn.mfEmptyTmp",
    "ATGn.mfEmptyTmp",
    "ATGTn.mfEmptyTmp",
    "ATn.mfEmptyTmp",
    "ATTCn.mfEmptyTmp",
    "ATTGn.mfEmptyTmp",
    "ATTn.mfEmptyTmp",
    "ATTTn.mfEmptyTmp",
    "CCCGn.mfEmptyTmp",
    "CCCTn.mfEmptyTmp",
    "CCGGn.mfEmptyTmp",
    "CCGn.mfEmptyTmp",
    "CCGTn.mfEmptyTmp",
    "CCTGn.mfEmptyTmp",
    "CCTn.mfEmptyTmp",
    "CCTTn.mfEmptyTmp",
    "CGCTn.mfEmptyTmp",
    "CGGGn.mfEmptyTmp",
    "CGGn.mfEmptyTmp",
    "CGGTn.mfEmptyTmp",
    "CGn.mfEmptyTmp",
    "CGTn.mfEmptyTmp",
    "CGTTn.mfEmptyTmp",
    "Cn.mfEmptyTmp",
    "CTGGn.mfEmptyTmp",
    "CTGn.mfEmptyTmp",
    "CTGTn.mfEmptyTmp",
    "CTn.mfEmptyTmp",
    "CTTGn.mfEmptyTmp",
    "CTTn.mfEmptyTmp",
    "CTTTn.mfEmptyTmp",
    "DirectRepeats.mfEmptyTmp",
    "Empty.mfEmptyTmp",
    "GGGTn.mfEmptyTmp",
    "GGTn.mfEmptyTmp",
    "GGTTn.mfEmptyTmp",
    "Gn.mfEmptyTmp",
    "GQuadMinus.mfEmptyTmp",
    "GQuadPlus.mfEmptyTmp",
    "GTn.mfEmptyTmp",
    "GTTn.mfEmptyTmp",
    "GTTTn.mfEmptyTmp",
    "InvertedRepeats.mfEmptyTmp",
    "MirrorRepeats.mfEmptyTmp",
    "Tn.mfEmptyTmp",
    "ZDNAMotifs.mfEmptyTmp"
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