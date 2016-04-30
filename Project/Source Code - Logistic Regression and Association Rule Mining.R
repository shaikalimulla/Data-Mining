#Logistic Regression to predict rating for given independent variables like genre, gender 
#and occupation. The below code for the logistic regression analysis.

install.packages(c("Amelia", "popbio", "ggplot2", "Hmisc", "plyr", "RColorBrewer", "grid", "arules"))

library(ggplot2)
library(plyr)
library(RColorBrewer)
library(grid)
library(arules)
library(Amelia)


movieRawData <- read.csv('unifiedDataMulti.csv',header=T,na.strings=c(""))

sapply(movieRawData,function(x) sum(is.na(x)))

sapply(movieRawData, function(x) length(unique(x)))

missmap(movieRawData, main = "Missing values vs Observed")
dev.copy(png,'missing_Values.png')
dev.off()


movieRawData$rating <- factor(movieRawData$rating)
movieRawData$release_date <- factor(movieRawData$release_date)
movieRawData$age <- factor(movieRawData$age)
movieRawData$occupation <- factor(movieRawData$occupation)
movieRawData$genre <- factor(movieRawData$genre)
movieRawData$userId <- factor(movieRawData$userId)
summary(movieRawData)

library(Hmisc)
describe(movieRawData)

movieGLMModel <- glm(rating ~ genre+gender+occupation,family=binomial(link='logit'),data=movieRawData)
print(summary(movieGLMModel))

print ("GLM Done")

print(anova(movieGLMModel, test="Chisq"))
print("Anova Done")

#plot(movieGLMModel)
#dev.copy(png,'myplot.png')
#dev.off()


library(ggplot2)
ggplot(log_data, aes(x=rating, y=genre)) + geom_point() + stat_smooth(method="glm", se=FALSE)
ggsave(filename = "temp.pdf")
ggplot(log_data, aes(x=rating, y=gender)) + geom_point() + stat_smooth(method="glm", se=FALSE)
ggsave(filename = "temp2.pdf")
ggplot(log_data, aes(x=rating, y=occupation)) + geom_point() + stat_smooth(method="glm", se=FALSE)
ggsave(filename = "temp3.pdf")

library(popbio)
plot(movieRawData$gender, movieRawData$rating, xlab="gender",ylab="Probability of rating")
dev.copy(png,'myplot.png')
dev.off()
plot(movieRawData$genre, movieRawData$rating, xlab="genre",ylab="Probability of rating")
dev.copy(png,'myplot2.png')
dev.off()
plot(movieRawData$occupation, movieRawData$rating, xlab="occupation",ylab="Probability of rating")
dev.copy(png,'myplot3.png')
dev.off()

logi.hist.plot(movieRawData$rating,movieRawData$age,boxp=FALSE,type="hist",col="gray")
dev.copy(png,'rating_age.png')
dev.off()
logi.hist.plot(movieRawData$rating,movieRawData$gender,boxp=FALSE,type="hist",col="gray")
dev.copy(png,'rating_gender.png')
dev.off()
logi.hist.plot(movieRawData$rating,movieRawData$genre,boxp=FALSE,type="hist",col="gray")
dev.copy(png,'rating_genre.png')
dev.off()
logi.hist.plot(movieRawData$rating,movieRawData$occupation,boxp=FALSE,type="hist",col="gray")
dev.copy(png,'rating_occupation_new.png')
dev.off()


#I have done association rule mining to find intersting patterns for the user rating, for the
#given genre, gender and occupation. The below code is related association rule mining.

install.packages(c("arules"))

library(arules)

movieData <- read.csv("unifiedDataMulti.csv", colClasses=c("NULL","NULL",NA,NA,"NULL",NA,NA,NA))

attach(movieData)
write.csv(movieData, "demo.csv")

movieDataTrans = read.transactions("demo.csv", format = "basket", sep = ",", rm.duplicates=TRUE)

rules <- apriori(movieDataTrans, parameter = list(minlen=2, supp=0.005, conf=0.8))
rules.sorted <- sort(rules, by="lift")
inspect(rules.sorted)
#plot(rules.sorted)
print(rules.sorted)
