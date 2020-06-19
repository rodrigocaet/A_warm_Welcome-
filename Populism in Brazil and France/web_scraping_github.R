### Script to get Bolsonaro's speeches from "Camara dos Deputados" website.

## In this website there is a spreadshit with hiperlinks to the speeches. In each row of the spreadshit there is a speech.
## The other columns of the spreadshit are irrelevant for us.

## First get all the libraries we wil use
library(xml2) 
library(rvest) 
library(stringr)
library(httr)
require(XML)
require(stringi)


## The website shows only 50 rows of the spreadshit, and it continues in the next webpage. 
# We found it hard to change from one page to the next, because it is not in the same place in every spreadshit 
# (so we couldn't create a for loop)
# To solve this problem, we created a function that, given the link for the spreadshit and the number of rows, 
# it would enter in the hiperlink and get us the speech.

scrape <- function(link,number = 50){
  output <- c(NULL)
  
  for (i in seq(1,number*2,2)){           ## interestingly, the spreadshit had a hidden row between every two rows, so the speeches were only in odd numbers and the total number should be multiplied by 2.
    caminho <- paste0("//*[@id='content']/div/table/tbody/tr[",i,"]/td[4]/a")    ## this is the speech position in the spreadshit
    tbl.page <- link %>%
      read_html() %>%
      html_nodes(xpath=caminho) %>%
      html_attr("href")       ## here we get the hiperlink to the speech (with some character that we may have to delete)
    speechLink <- str_replace_all(tbl.page, '[\r\n]' , '')
    speechLink <- str_replace_all(speechLink, '[\r\t]' , '')
    speechLink <- URLencode(speechLink)
    
    ## This code enter in the website with the speech and copy it to add to the output vector
    Bozo <- paste0("https://www.camara.leg.br/internet/sitaqweb/",speechLink)
    First_speech <- read_html(Bozo)
    title_html <- html_nodes(First_speech, 'div#content')
    title <- html_text(title_html)
    texto <- str_replace_all(title, '[\r\n]' , '')
    texto <- str_replace_all(texto, '[\r\t]' , '')
    
    output <- c(output,texto)
  }
  return(output) 
}


## Now that we have our function to scrap each spreadshit, we will create a for loop to scrape all the spreadshits at once
allSpeeches <- c(NULL)
link <- "https://www.camara.leg.br/internet/sitaqweb/resultadoPesquisaDiscursos.asp?txOrador=jair+bolsonaro&txPartido=&txUF=&dtInicio=&dtFim=&txTexto=&txSumario=&basePesq=plenario&CampoOrdenacao=dtSessao&PageSize=50&TipoOrdenacao=DESC&btnPesq=Pesquisar"
# this is the first link

for(counter in 1:18){ ## there are 19 pages
  
  ## Here we scrap the link
  speech <- scrape(link)
  allSpeeches <- c(allSpeeches,speech)
  
  ## Now we get the next link to be scrapped
  next.page <- link %>%
    read_html() %>%
    html_nodes(xpath='//*[@id="content"]/div/div[3]/span/a[2]') %>%
    html_attr("href")
  
  next.page <- str_replace_all(next.page, ' ' , '%20')
  link <- paste0("https://www.camara.leg.br",next.page[length(next.page)])
  print(counter)
  
  if (counter == 17){  ## the last page has 35 speeches only
    speech <- scrape(link,35) 
    allSpeeches <- c(allSpeeches,speech)
  }
}

## The vector with all the speeches still needs some corrections:
for(i in 1:length(allSpeeches)){
  allSpeeches[i] <- gsub("^.*Sumário","",allSpeeches[i])
  allSpeeches[i] <- str_sub(allSpeeches[i], start= 1,end =-16)
}

## Now we reorder the table and create a .txt file to read it
require(tidyverse)
require(dplyr)
orderedSpeeches <- data.frame(seq(length(allSpeeches),1,-1),allSpeeches)
arrange(orderedSpeeches, orderedSpeeches[,1])
orderedSpeeches[,1] = NULL

write.table(orderedSpeeches,"textoEmOrdem.txt",sep = "\t",row.names = F)


