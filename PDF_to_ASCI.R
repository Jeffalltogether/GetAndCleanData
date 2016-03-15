# Convert PDF to ASCI
options(stringsAsFactors = FALSE)
# make a vector of PDF file names
path <- "C:\\Users\\jeffthatcher\\Cloud Drive\\RRepos\\SD\\RawData\\"
myfiles <- list.files(path = path,  full.names = TRUE)


# convert each PDF file that is named in the vector into a text file 
# text file is created in the same directory as the PDFs
# note that my pdftotext.exe is in a different location to yours
lapply(myfiles,
       function(i) system(paste('"C:/Users/jeffthatcher/Cloud Drive/xpdfbin/bin64/pdftotext.exe"', 
                                paste0('"', i, '"')), wait = FALSE) )


