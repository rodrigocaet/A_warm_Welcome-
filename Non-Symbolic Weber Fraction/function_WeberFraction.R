## Aknowledments: Pedro Pineiro Chagas and Ricado Jose de Moura for creating a function for calculating the Weber Fraction in other tasks and circuntances but that helped me to create this scprit, thank you!

library(stringr) 
library(readxl)
library(dplyr)

WeberROD <- function(dataframe,logname) {
  
  ## Se what task was the spreadsheet from
  if (ncol(dataframe) == 10){
    referencia = "16e32"
  }else if (ncol(dataframe) == 9){
    referencia = "16"
  }else {
    referencia = "32"
  }

  ## At first we will make the different tasks look alike (with the same columns etc) - and making a column called Response that indicates whether the trial was correctelly answered
  if (referencia == "32"){
    ## throwing away the "test" trials
    dataframe <- dataframe[9:72,] 
    
    # this is the sequence of right answers (given by the person who created the task)
    dataframe$Targ_button <- c(2,2,1,2,2,1,2,1,1,2,1,2,2,1,2,2,1,1,1,1,2,2,2,2,2,1,2,2,1,2,2,1,
                              1,2,1,2,2,2,2,2,1,2,1,1,1,1,2,2,2,1,2,1,1,1,2,2,1,1,1,2,1,1,1,1)
    # code the answer as 1 to right and 0 to wrong answers
    dataframe$Response  <- ifelse(is.na(dataframe$Button),NA,ifelse(dataframe$Targ_button == dataframe$Button, 1, 0))
    # taking the name of the child who did the test
    Crianca <- dataframe$Person_code[2]
  }
  if (referencia == "16e32"){
    # code the answer as 1 to right and 0 to wrong answers
    dataframe$Press_button <- as.factor(dataframe$pressbutton)
    dataframe$Response <- ifelse(dataframe$Press_button == 1 & dataframe$magleft > dataframe$magright,1,
                                ifelse(dataframe$Press_button == 2 & dataframe$magleft < dataframe$magright,1,
                                       ifelse(dataframe$Press_button == 2 & dataframe$magleft > dataframe$magright,0,
                                              ifelse(dataframe$Press_button == 1 & dataframe$magleft < dataframe$magright,0,NA))))
    dataframe$Response <- as.numeric(dataframe$Response)

    # change the name of the columns
    dataframe$Reaction_time = dataframe$rt
    Crianca <- dataframe$participant[2]
    dataframe$Person_code <- dataframe$participant
  }
  
  if(referencia == "16"){
    # code the answer as 1 to right and 0 to wrong answers
    dataframe$Pressed_Button <- as.factor(dataframe$Pressed_Button)
    dataframe$Response <- ifelse(dataframe$Pressed_Button == 1 & dataframe$Mag_left > dataframe$Mag_right,1,
                                ifelse(dataframe$Pressed_Button == 2 & dataframe$Mag_left < dataframe$Mag_right,1,
                                       ifelse(dataframe$Pressed_Button == 1 & dataframe$Mag_left < dataframe$Mag_right,0,
                                              ifelse(dataframe$Pressed_Button == 2 & dataframe$Mag_left > dataframe$Mag_right,0,NA))))
    dataframe$Response <- as.numeric(dataframe$Response)
    
    # change the name of the columns
    dataframe$Reaction_time = dataframe$RT
    Crianca <- dataframe$Subject_ID[2]
    dataframe$Person_code <- dataframe$Subject_ID
  }
  
  ## Counting how many trials the child didn't even tried
  del <- nrow(dataframe)
  dataframe <- subset(dataframe, Response != "NA")
  nROWqueNAOrespondeu <- del - nrow(dataframe)
  
  ## Inserting the ratios
  if(referencia == "32"){
    dataframe$Ratios <- c(1.375,1.094,1.281,1.6,1.1,1.1,1.23,1.188,1.6,1.39,1.39,1.188,1.39,1.094,1.375,1.6,1.6,1.375,1.6,1.39,
                         1.1,1.281,1.188,1.281,1.23,1.281,1.094,1.6,1.094,1.281,1.39,1.281,1.39,1.23,1.375,1.188,1.1,1.23,1.281,1.23,1.375,1.094,1.39,1.094,
                         1.188,1.094,1.6,1.375,1.1,1.6,1.375,1.1,1.23,1.188,1.188,1.094,1.23,1.1,1.188,1.39,1.281,1.375,1.1,1.23)
    # ratio linear é considerando apenas dividindo sempre o experimental pelo controle (o número divido por 32)
    dataframe$RatioLinear <- ifelse(dataframe$Ratios == 1.60, 0.625, ifelse(dataframe$Ratios == 1.39, 0.719, 
                                                                          ifelse(dataframe$Ratios == 1.23 , 0.813, ifelse(dataframe$Ratios == 1.10 , 0.906 , dataframe$Ratios))))
    
    dataframe$Ratios <- as.factor(dataframe$Ratios)
    dataframe$RatioLinear <- as.factor(dataframe$RatioLinear)
  }
  if(referencia == "16e32"){
    # creating the ratios
    dataframe$RatioLinear <- ifelse(dataframe$magleft == 16 | dataframe$magleft == 32, dataframe$magright/dataframe$magleft, dataframe$magleft/dataframe$magright)
    dataframe$RatioLinear <- round(dataframe$RatioLinear, digits= 3)
    dataframe$RatioLinear <- as.factor(dataframe$RatioLinear)
  }
  if(referencia == "16"){
    # creating the ratios
    dataframe$RatioLinear <- ifelse(dataframe$Mag_left == 16,dataframe$Mag_right/16,dataframe$Mag_left/16)
    dataframe$RatioLinear <- as.factor(dataframe$RatioLinear)
  }
  
  dataframe <- dataframe[order(dataframe$RatioLinear),] # ordering the dataframe
  a <- as.numeric(by(dataframe$Response, dataframe$RatioLinear, sum)) # number of right answer by ratios
  b <- as.numeric(by(dataframe$Response, dataframe$RatioLinear, length)) # number of trials por ratios
  
  ## Taking the number of trials that the child said the array in the left had more dots (so it is the mistakes for the first ratios and the right answers for the others)
  larger <- c( (1-((a[1:(length(a)/2)])/(b[1:(length(a)/2)]))),((a[(length(a)/2 + 1):length(a)])/(b[(length(a)/2 + 1):length(a)])))
  
  ratio <- as.numeric(c(levels(dataframe$RatioLinear)))
  
  ## Now we will filter the dataframe to not include the values of the missed trials (before we were including it as mistakes)
  logs = dataframe
  for (i in 1:3){ ## Podemos duas vezes, que nem o filtro do excel, mas optei por fazer 3 vezes que nem o antigo script do R mesmo
    #Podando RT 
    media_rt <- as.numeric(mean(logs$Reaction_time))
    dp_rt <- as.numeric(sd(logs$Reaction_time))
    count_subj <- as.numeric(by(logs$Reaction_time, logs$Person_code, length)) #pegar o número de trials
    logs$RT_cut_h <- c(rep((media_rt + (3*dp_rt)),count_subj)) #vetor com valores 64 vezes (pq é o numero de linhas, pra comparar depois) m+3dp
    logs$RT_cut_l <- c(rep((media_rt - (3*dp_rt)),count_subj)) #vetor com valores 64 vezes m-3dp
    
    logs <- subset(logs, Reaction_time >= logs$RT_cut_l & Reaction_time <= logs$RT_cut_h & Reaction_time > 200)
  }
  
  ## agora estamos calculando novamente o número de largers, só que os RTs podados
  a1 <- as.numeric(by(logs$Response, logs$RatioLinear, sum)) #total de acertos por raz?o
  b1 <- as.numeric(by(logs$Response, logs$RatioLinear, length)) # n de trials por raz?o, tirando as filtradas
  
  # aqui é pra gente pegar dividir pelo número de trials que o sujeito tentou, ou seja, considerando as trials filtradas como nem tentadas (tirando as trials filtradas)
  largersemFilt <- c( (1-((a1[1:(length(a)/2)])/(b1[1:(length(a)/2)]))),((a1[(length(a1)/2 + 1):length(a1)])/(b1[(length(a1)/2 + 1):length(a1)])))
  
  # tambem vou fazer considerando as trials filtradas como erradas(ou seja, dividir por 8)
  b2 <- rep(8,length(b1))
  largercomFilt <- c( (1-((a1[1:(length(a)/2)])/(b2[1:(length(a)/2)]))),((a1[(length(a1)/2 + 1):length(a1)])/(b2[(length(a1)/2 + 1):length(a1)])))
  
  
  # Fra??o de Weber
  erf <- function(x) 2* pnorm(x*sqrt(2)) -1 #(funcao do erro)
  
  webersemFilt <- nls(largersemFilt ~ 0.5*(1 + erf(log(ratio)/(sqrt(2)*w))), start = list(w=0.2))
  webercomFilt <- nls(largercomFilt ~ 0.5*(1 + erf(log(ratio)/(sqrt(2)*w))), start = list(w=0.2))
  
  myWcomFilt <- summary(webercomFilt, correlation = TRUE, symbolic.cor = TRUE)
 
  ## Calculating the fit
  numerador1 <- 0
  denominador1 <- 0
  for(i in 1:length(ratio)){
    numerador1 <- numerador1 + (0.5*(1 + erf(log(ratio[i])/(sqrt(2)*myWcomFilt$parameters[1])))-largercomFilt[i])^2
    denominador1 <- denominador1 + (mean(largercomFilt) - largercomFilt[i])^2
  }
  r_squared_comFilt <- 1 - numerador1/denominador1
  nrItercomFilt <- myWcomFilt$convInfo$finIter
  
  myWsemFilt <- summary(webersemFilt, correlation = TRUE, symbolic.cor = TRUE)
  
  ## R-squared
  {
    denominador <- 0
    numerador <- 0
    for(i in 1:length(ratio)){
      numerador <- numerador + (0.5*(1 + erf(log(ratio[i])/(sqrt(2)*myWsemFilt$parameters[1])))-largersemFilt[i])^2
      denominador <- denominador + (mean(largersemFilt) - largersemFilt[i])^2
    }
    r_squared_semFilt <- 1 - numerador/denominador

  }
  
  ## calculo do P de acordou com o artigo do Lyons 2014
  RT = mean(dataframe$Reaction_time[dataframe$Response==1],na.rm = T)
  ER = mean(dataframe$Response==1,na.rm = T)
  p = RT * (1+2*ER)
  
  nrItersemFilt <- myWsemFilt$convInfo$finIter
  ntrialsFiltradas <- nrow(dataframe) - nrow(logs)
  
  cnames <- c("Planilha","Criança","Referencia","pLyons2014",
              "myWcomFilt$parameters[1]",
              "nossoRquadradocomFilt", "nrItercomFilt",
              "myWsemFilt$parameters[1]",
              "nossoRquadradosemFilt", "nrItersemFilt",
              "numero de trials que a crianca nem respondeu",
              "diferença de trials total")

  
  rrr <- c(logname,Crianca,referencia,p,myWcomFilt$parameters[1], #rcomFilt$pseudo.R.squared,
           r_squared_comFilt,nrItercomFilt, 
           myWsemFilt$parameters[1],
           r_squared_semFilt, nrItersemFilt, 
           nROWqueNAOrespondeu,
           ntrialsFiltradas)
  
  data_w <- matrix()
  data_w <- rbind(rrr)
  colnames(data_w) <- cnames
  rownames(data_w) <- logname
  
  return(data_w)
}
