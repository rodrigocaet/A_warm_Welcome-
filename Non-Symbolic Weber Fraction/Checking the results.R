library(haven)
library(stringr) 
library(readxl)

## First we read the data from all projects (in this data, there are some children that already have the Weber Fraction calculated by hand. The previous results are in the "w" column)
basao2 <- read_sav("Basao_12_05_2020.sav")

##### First we will work with data only from the "Discalculia" projetc: ######

## We have the data that we calculated the weber fraction with the function in "plan1"
a <- basao2[basao2$Project == 0,] ## get only the children from dicalculia
b <- a[!is.na(a$w),] ## get only those who had w

## here we get the Id of the children we calculated
Id <- rep(NA,length(plan1$Planilha))
Id <- gsub('\\.','', plan1$Planilha)
for (i in 1:length(plan1$Planilha)){ ## tem que fazer esse for varias vezes pra tirar todos os 0
  Id[i] <- ifelse(str_sub(Id[i], end = 1) == "0",str_sub(Id[i], start = 2),Id[i])
}
plan1$Id <- str_sub(Id, end = -6) 
basaoAndPlan1 = merge(x = b,y = plan1,by.x = "Identification",by.y = "Id",all.x = T)


plan1$link = rep(NA,length(plan1$Planilha))
for (i in 1:length(plan1$Planilha)){
  plan1$link[i] <- ifelse(plan1$Id[i] %in% b$Identification,plan1$Id[i],NA)
}
planDiscalc <- plan1


dim(as.data.frame(b[!(b$Identification %in% basaoAndPlan1$Identification),"Identification"]))
length(plan1[!(plan1$Id %in% basaoAndPlan1$Identification),"Id"])

v <- data.frame("dobasao" = basao2[basao2$Identification %in% plan1[!(plan1$Id %in% basaoAndPlan1$Identification),"Id"],"Identification"],
                "nomebasao" = b[!(b$Identification %in% basaoAndPlan1$Identification),"Name"],
                "docalculo" = c(plan1[!(plan1$Id %in% basaoAndPlan1$Identification),"Id"],NA,NA,NA,NA,NA),
                "nomecalculo" = c(plan1[!(plan1$Id %in% basaoAndPlan1$Identification),"Criança"],NA,NA,NA,NA,NA))


planDiscalc %>%
  is.na() %>%
  colSums()
### I didn't find the scripts of the output dataframes for discalculia (like salvar1, salvar2, etc), but the code is very similar to those for Endofenotipos (salvarEndo1, salvarEndo2, etc)

########Work with the Endofenotipos project ########

## On the spreadshits from this project, the name of the children on the task wasnt the name in project, they had this "codigo escolas" spreadshit as a link. Here I manage to get the identifications by those spreadshits.
plan1$Criança[is.na(plan1$Criança)] <- "erro"
plan1$link = rep(NA,length(plan1$Planilha))
escolasNULAS <- c()
setwd("~/Desktop/escolas_código")
planilhas <- c(list.files(getwd(),recursive=T))
for(escola in planilhas){
  link <- read_xlsx(escola)
  link <- link[!is.na(link$code),]
  for(i in 1:length(link$code)){
    dummy <- data.frame(c("a","b","c"))
    try(dummy <- read_xlsx(escola,sheet = toString(link[i,1])))
    if(dummy[3,1] %in% plan1$Criança){
      plan1$link[plan1$Criança == toString(dummy[3,1])] <- toString(link[i,"code"])
      print(paste(escola,i))
    }
    else{
      escolasNULAS <- c(escolasNULAS,paste0(escola,length(link$code)))
    }
  }
}
sum(!is.na(plan1$link))
length(unique(plan1$link))
sum(is.na(plan1$link))
table(escolasNULAS)
planEndo <- plan1
  
write.csv(planEndo,"planEndocomLink.csv")

### To check the number of missing values in each column
planEndo %>%
  is.na() %>%
  colSums()

## Checking if the Id in the spreadshit "escola" match the basao Identification
for (i in 1:length(planEndo$link)){
  if(planEndo$link[i] %in% basao2$Identification){
    t <- 1
  }else{
    if(str_sub(planEndo$link[i],start = 2) %in% basao2$Identification){
      planEndo$link[i] <- str_sub(planEndo$link[i],start = 2)
    }else{
    print(planEndo$link[i] )
    }
  }
}


## Dataframes that presented errors:
deramErro <- planEndo[planEndo$Criança == "erro",c("link","Planilha")]
planEndo4 <- planEndo[!(rownames(planEndo) %in% rownames(deramErro)),]

## This is the list of children that have two tasks in their name (probably because the first one had a mistake)
a <- as.data.frame(table(as.numeric(planEndo4$link)))
b <- a[a$Freq > 1,"Var1"]
c <- planEndo4[as.numeric(planEndo4$link) %in% b,c("Criança","link","Planilha")]
c$link <- as.numeric(c$link)
repetidos <- c[order(c$link),]

planEndo5 <- planEndo4[!(rownames(planEndo4) %in% rownames(repetidos)),]


# This is the list of the ones that doesnt have a match in basao (the dataset of all projects together)
planEndoNAs <- planEndo5[is.na(planEndo5$link),]
planEndo6 <- planEndo5[!is.na(planEndo5$link),]

### The dataframes below are explained in a word document on the lab's drive or my github
salvarEndo1 <- planEndo2[is.na(planEndo3$Referencia),]
salvarEndo1 <- salvarEndo1[salvarEndo1$Criança != "erro",]
dim(salvarEndo2)
salvarEndo6 <- planEndo3[planEndo3$link %in% repetidos$link,]
salvarEndo3 <- planEndo6[!is.na(planEndo6$Referencia),]
dim(planEndo3)
write.csv(planEndo3,"planEndo.csv")
write.csv(salvarEndo0,"salvarEndo0.csv")
write.csv(salvarEndo1,"salvarEndo1.csv")
write.csv(salvarEndo2,"salvarEndo2.csv")
a <- salvarEndo6[rownames(salvarEndo6) %in% c(383,441,667),]
salvarEndo7 <- rbind(salvarEndo3,a)
write.csv(salvarEndo7,"salvarEndo3.csv")
write.csv(salvarEndo6,"salvarEndo6.csv")
b <- basao2[basao2$Project == "1",]
salvarEndo4 <- b[!is.na(b$w) & !(b$Identification %in% planEndo3$link),c("Identification","Name")]
salvarEndo5 <- salvarEndo3[salvarEndo3$link %in% b$Identification[is.na(b$w)],]
write.csv(salvarEndo4,"salvarEndo4.csv")
write.csv(salvarEndo5,"salvarEndo5.csv")

