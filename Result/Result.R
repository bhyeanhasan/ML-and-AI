
setwd("C:/Users/NoYoN/Desktop/ML-and-AI/Result")

train <- read.csv("C:/Users/NoYoN/Desktop/ML-and-AI/Result/bh.csv")

test <- read.csv("C:/Users/NoYoN/Desktop/ML-and-AI/Result/test.csv")



install.packages("Amelia")
library(Amelia)
missmap(train, main = "Missing Data", col = c("yellow", "black"), legend=FALSE)
prop.table (table(train$Sex, train$Survived),1)*100




install.packages('rattle')
install.packages('rpart.plot')
install.packages('RColorBrewer')


library(rpart)
library(rattle)
library(rpart.plot)
library(RColorBrewer)


mytree3 <- rpart(Result ~  Value, data=train, method="class")
plot(mytree3)
text(mytree3)
fancyRpartPlot(mytree3)


prediction4th <- predict(mytree3, test, type = "class")
prediction4 <- data.frame(class = test$Class, Result = prediction4th)
write.csv(prediction4, file = "tree1.csv", row.names = FALSE)





test$Survived <- NA
test$Fare2 <- NA



combined_set <- rbind(train, test)

view(combined_set)
view(train)
view(test)




combined_set$Name <- as.character(combined_set$Name)
combined_set$Child[combined_set$Age < 14] <- 'Child'
combined_set$Child[combined_set$Age >= 14] <- 'Adult'

table(combined_set$Child, combined_set$Survived)

combined_set$Child <- factor(combined_set$Child)

combined_set$Mother <- 'Not Mother'
combined_set$Mother[combined_set$Sex == 'female' & combined_set$Parch > 0 & combined_set$Age > 18] <- 'Mother'
table(combined_set$Mother, combined_set$Survived)


combined_set$Mother <- factor(combined_set$Mother)


combined_set$Name[1]

strsplit(combined_set$Name[1], split='[,.]')[[1]][2]

combined_set$Title <- sapply(combined_set$Name, FUN=function(x) {strsplit(x, split='[,.]')[[1]][2]})



combined_set$Title

combined_set$Title <- sub(' ', '', combined_set$Title)

table(combined_set$Title)

combined_set$Title[combined_set$Title %in% c('Mme', 'Mlle')] <- 'Mlle'
combined_set$Title[combined_set$Title %in% c('Capt', 'Don', 'Major', 'Sir')] <- 'Sir'
combined_set$Title[combined_set$Title %in% c('Dona', 'Lady', 'the Countess', 'Jonkheer')] <- 'Lady'





combined_set$Title <- factor(combined_set$Title)
combined_set$Mother <- 'Not Mother'
combined_set$Mother[combined_set$Sex == 'female' & combined_set$Parch > 0 & combined_set$Age > 18 & combined_set$Title != 'Miss'] <- 'Mother'


combined_set$Mother





combined_set$Cabin[1:20]

combined_set$Cabin <- as.character(combined_set$Cabin)
strsplit(combined_set$Cabin[2], NULL)[[1]]
combined_set$Deck<-factor(sapply(combined_set$Cabin, function(x) strsplit(x, NULL)[[1]][1]))
combined_set$Deck
combined_set$Fare_type[combined_set$Fare<50]<-"low"
combined_set$Fare_type[combined_set$Fare>50 & combined_set$Fare<=100]<-"med1"
combined_set$Fare_type[combined_set$Fare>100 & combined_set$Fare<=150]<-"med2"
combined_set$Fare_type[combined_set$Fare>150 & combined_set$Fare<=500]<-"high"
combined_set$Fare_type[combined_set$Fare>500]<-"vhigh"
aggregate(Survived~Fare_type, data=combined_set,mean)


combined_set$FamilySize <- combined_set$SibSp + combined_set$Parch + 1
combined_set$Surname <- sapply(combined_set$Name, FUN=function(x) {strsplit(x, split='[,.]')[[1]][1]})
combined_set$Surname
aggregate(Survived~Surname, data=combined_set,mean)
combined_set$FamilyID <- paste(as.character(combined_set$FamilySize), combined_set$Surname, sep="")
combined_set$FamilyID
combined_set$FamilyID[combined_set$FamilySize <= 2] <- 'Small'
combined_set$FamilySizeGroup[combined_set$FamilySize == 1] <- 'single'
combined_set$FamilySizeGroup[combined_set$FamilySize < 5 & combined_set$FamilySize > 1] <- 'Smaller'
combined_set$FamilySizeGroup[combined_set$FamilySize > 4] <- 'large'
mosaicplot(table(combined_set$FamilySizeGroup, combined_set$Survived), main='Survival affected by Family Size ', shade=TRUE)
table(combined_set$FamilyID)
combined_set$FamilyID <- factor(combined_set$FamilyID)
combined_set$FamilySizeGroup <- factor(combined_set$FamilySizeGroup)
train <- combined_set[1:891,]
test <- combined_set[892:1309,]
fit <- rpart(Survived ~ Pclass + Sex + Age + SibSp + Parch + Fare + Embarked + Title + FamilySize + FamilyID,data=train, method="class")







fancyRpartPlot(fit)
prediction_5th <- predict(fit, test, type = "class")
submit <- data.frame(PassengerId = test$PassengerId, Survived = prediction_5th)
write.csv(submit, file = "prediction5th.csv", row.names = FALSE)
