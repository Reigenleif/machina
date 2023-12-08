# Importing dataset
dataset = read.csv('Data.csv')

# install.packages('caTools')
library(caTools)
set.seed(123)
split = sample.split(dataset$PE, SplitRatio = .8)
training_set = subset(dataset, split == TRUE)
test_set = subset(dataset, split == FALSE)

training_set[, 2:3] = scale(training_set[, 2:3]) 
test_set[, 2:3] = scale(test_set[, 2:3])

# Installing libraries
# install.packages('e1071')
# install.packages('rpart')
# install.packages('randomForest')
library(e1071)
library(rpart)
library(randomForest)

lin_reg = lm(formula = PE ~ .,
             data = training_set)
sv_reg = svm(formula = PE ~ .,
             data = training_set)
dt_reg = rpart(formula = PE ~ .,
               data = training_set,
               control = rpart.control(minsplit = 1))
rf_reg = randomForest(x = training_set[,1:5],
                      y = training_set$PE,
                      ntree = 10)

# printing summaries
summary(lin_reg)
summary(sv_reg)
summary(dt_reg)
summary(rf_reg)

