library(ggplot2)
library(dplyr)

## First we import a pre-processed data called portesbnec
Dados  <- read.csv("postersbnec.csv",header = T,sep=";")

## Separating the two groups I wanted to analyse
Dados <- arrange(Dados,Raven_percentile)
dados <- Dados[-seq(1,69),]
dados <- dados[dados$Groups_MG == 0 | dados$Groups_MG == 1,]
dados$Groups_MG <- as.factor(dados$Groups_MG)
levels(dados$Groups_MG)[levels(dados$Groups_MG)=="1"] <- "MLD"
levels(dados$Groups_MG)[levels(dados$Groups_MG)=="0"] <- "TA"

## Excluding missing values
dados <- dados[!is.na(dados$Groups_MG),]
dados <- dados[!is.na(dados$Corsi_B_span),]
dados <- dados[!(is.na(dados$Mul_S_Total)),]
dados <- dados[!(is.na(dados$Mul_C_Total)),]
dados <- dados[!(is.na(dados$Add_S_Total)),]
dados <- dados[!(is.na(dados$Add_C_Total)),]
dados <- dados[!(is.na(dados$Sub_S_Total)),]
dados <- dados[!(is.na(dados$Sub_C_Total)),]
dados <- dados[!(is.na(dados$Corsi_B_span)),]
dados <- dados[!(is.na(dados$w)),]

## Creating the new variables used to perform the analysis and making the graphics
dados$add_total <- dados$Add_S_Total + dados$Add_C_Total
dados$sub_total <- dados$Sub_S_Total + dados$Sub_C_Total
dados$mult_total <- dados$Mul_S_Total + dados$Mul_C_Total



## Checking the T-test assumptions
# normality
shapiro.test(dados$Corsi_B_span)
shapiro.test(dados$w)
hist(dados$Corsi_B_span)
hist(dados$w)
# homeodascity
var.test(dados$Groups_MG,y=dados$Corsi_B_span)
var.test(dados$Groups_MG,y=dados$w)

## performing the t-test
t.test(dados$Corsi_B_span~dados$Groups_MG,var.equal = F)
t.test(dados$w~dados$Groups_MG, var.equal = F)

## Getting the mean and standard error to make the graphics
bancodedados <- dados %>%
  group_by(Groups_MG) %>%
  summarise(mean_W = mean(w), mean_Corsi = mean(Corsi_B_span),
            SE_W = sd(w)/sqrt(n()), SE_Corsi = sd(Corsi_B_span)/sqrt(n()))

## The first visualizations I made were comparing the score in two tests for the TA and MLD groups with their standard error.
ggplot(bancodedados, aes(x= Groups_MG,y=mean_Corsi,fill = Groups_MG)) + geom_col() + 
  geom_errorbar(aes(ymin = mean_Corsi - SE_Corsi, ymax = mean_Corsi + SE_Corsi), width = 0.2) +
  scale_fill_manual(values= c("blue3","red3")) +  
  labs(x = "",y = "", title = "Backwards Corsi Cubes") +
  theme_classic() + theme(plot.title = element_text(hjust = 0.5,size = 20,face = "bold")) +
  scale_y_continuous("Mean span", c(0,1,2,3,4,5),limits = c(0,5))

ggplot(bancodedados, aes(x= Groups_MG,y=mean_W, fill = Groups_MG)) + geom_col() + 
  geom_errorbar(aes(ymin = mean_W - SE_W, ymax = mean_W + SE_W), width = 0.2) +
  scale_fill_manual(values= c("blue3","red3")) +  
  labs(x = "",y = "", title = "Non-symbolic comparison task") +
  theme_classic() + theme(plot.title = element_text(hjust = 0.5,size = 20,face = "bold")) +
  scale_y_continuous("Mean Weber fraction",limits = c(0,0.4))


## After that I made correlations plots to 
## separating the data in two data.frames to perform different correlations test for TA and MLD
dados$aritm <- dados$add_total+ dados$sub_total + dados$mult_total
cormld <- dados[dados$Groups_MG == "MLD",]
corta <- dados[dados$Groups_MG == "TA",]

## checking the correlation scores
cor.test(x = cormld$aritm, y= cormld$Corsi_B_span, method = "pearson")
cor.test(x = cormld$aritm, y= cormld$w, method = "pearson")
cor.test(x = corta$aritm, y= corta$Corsi_B_span, method = "pearson")
cor.test(x = corta$aritm, y= corta$w, method = "pearson")

## plot
ggplot(data= dados, aes(x = w,y= add_total+ sub_total + mult_total, color = Groups_MG)) + 
  geom_point() + scale_color_manual(values= c("blue3","red3")) + 
  theme( panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.border = element_blank(), panel.background = element_blank()) +
  annotate(geom="text", x=0.55, y=76, label = c("r = -.29, p<0.001") , color="blue3", size=3)+
  annotate(geom="text", x=0.555, y=72, label = c("r = -.23, p<.01") , color="red2", size=3)  +
  labs (x = "Weber's fraction",y = "Arithmetic task", title = "Non-symbolic comparison task", color = "Groups")+ geom_smooth(method = "lm", se=F) +
  theme(axis.line = element_line(colour = "black", size = 0.3), panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.border = element_blank(), panel.background = element_blank())  

ggplot(data= dados, aes(x = Corsi_B_span,y= add_total+ sub_total + mult_total, color = Groups_MG)) + 
  geom_point() + scale_color_manual(values= c("blue3","red3")) + 
  theme( panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.border = element_blank(), panel.background = element_blank()) +
  annotate(geom="text", x=1, y=76, label = c("r = -.16, p=.33") , color="blue3", size=3)+
  annotate(geom="text", x=1, y=72, label = c("r = -.23, p<.01") , color="red2", size=3)  +
  labs (x = "span",y = "Arithmetic task", title = "Backwards Corsi cubes", color = "Groups")+ geom_smooth(method = "lm", se=F) +
  theme(axis.line = element_line(colour = "black", size = 0.3), panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.border = element_blank(), panel.background = element_blank())+
  scale_x_continuous("Mean span", c(2,3,4,5,6,7),limits = c(0,8))
