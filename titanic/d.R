
setwd("C:/Users/NoYoN/Desktop/titanic")

train <- read.csv("C:/Users/NoYoN/Desktop/titanic/train.csv")
train
View(train)


test <- read.csv("C:/Users/NoYoN/Desktop/titanic/test.csv")
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
