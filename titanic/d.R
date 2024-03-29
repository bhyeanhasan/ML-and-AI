
setwd("C:/Users/NoYoN/Desktop/ML-and-AI/titanic")

train <- read.csv("C:/Users/NoYoN/Desktop/ML-and-AI/titanic/train.csv")
train
View(train)


test <- read.csv("C:/Users/NoYoN/Desktop/ML-and-AI/titanic/test.csv")
test
View(test)

table(train$Survived) 

prop.table(table(train$Survived))*100

test$Survived <- rep(0,418)
test


predictans <- data.frame (PassengerId = test$PassengerId, Survived = test$Survived)
write.csv (predictans, file = "bh.csv", row.names = FALSE)


install.packages("Amelia")
library(Amelia)
train$Cabin [train$Cabin == ''] <- NA

missmap(train, main = "Missing Data", col = c("yellow", "black"), legend=FALSE)


prop.table (table(train$Sex, train$Survived),1)*100


test$Survived<- 0
test$Survived [test$Sex == 'female'] <-1

predict2 <- data.frame(PassengerId=test$PassengerId,Survived= test$Survived)
write.csv(predict2, file = "second.csv",row.names = FALSE)


train$Fare2 <- '30+'
train$Fare2[train$Fare < 30 & train$Fare >= 20] <- '20-30'
train$Fare2[train$Fare < 20 & train$Fare >= 10] <- '10-20'
train$Fare2[train$Fare < 10] <- '<10'

aggregate(Survived ~ Fare2 + Pclass + Sex, data=train, FUN=sum)


aggregate(Survived ~ Fare2 + Pclass + Sex, data=train, FUN=length)


aggregate(Survived ~ Fare2 + Pclass + Sex, data=train, FUN=function(x) {sum(x)/length(x)})


aggregate(Survived ~ Pclass + Sex, data=train, FUN=function(x) {sum(x)/length(x)})


test$Survived <- 0
test$Survived[test$Sex == 'female'] <- 1
test$Survived[test$Sex == 'female' & test$Pclass == 3 & test$Fare >= 20] <- 0
prediction3rd <- data.frame (test$PassengerId, test$Survived)
names (prediction3rd) <- c("PassengerId","Survived")
rownames (prediction3rd) <- NULL
write.csv (prediction3rd, file = "prediction3.csv", row.names=FALSE)


install.packages('rattle')
install.packages('rpart.plot')
install.packages('RColorBrewer')


library(rpart)
library(rattle)
library(rpart.plot)
library(RColorBrewer)
mytree1 <- rpart(Survived ~ Sex, data=train, method="class")
fancyRpartPlot(mytree1)
mytree2 <- rpart(Survived ~Sex+ Pclass + Age, data=train, method="class")
fancyRpartPlot(mytree2)


mytree3 <- rpart(Survived ~ Pclass + Sex + Age + SibSp + Parch + Fare + Embarked, data=train, method="class")
plot(mytree3)
text(mytree3)
fancyRpartPlot(mytree3)


prediction4th <- predict(mytree3, test, type = "class")
prediction4 <- data.frame(PassengerId = test$PassengerId, Survived = prediction4th)
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
