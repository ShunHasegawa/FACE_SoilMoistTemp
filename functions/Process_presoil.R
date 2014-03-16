#function which processes the files which are not on HIVe
#####
processPresoil <- function(){
  #the following files are not on HIEv
  prefiles <- dir(pattern="20130603") 
  presoils <- lapply(prefiles,readTOA5) #make a list
  presoilData <- rbind.fill(presoils) #combine
  return(presoilData)
}
presoilData <- processPresoil()
presoilData <- presoilData[!duplicated(presoilData),]
save(presoilData,file="output/presoilData.R")
#####