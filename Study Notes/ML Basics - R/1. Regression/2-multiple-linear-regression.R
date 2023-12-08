# Preprocessing
dataset = read.csv('50_Startups.csv')

# install.packages('caTools')
dataset$State = factor(dataset$State,
                         levels = c('New York', 'Florida', 'California'),
                         labels = c(1,2,3))

library(caTools)
set.seed(123)
split = sample.split(dataset$Profit, SplitRatio = .8)
training_set = subset(dataset, split == TRUE)
test_set = subset(dataset, split == FALSE)

training_set[, 2:3] = scale(training_set[, 2:3]) 
test_set[, 2:3] = scale(test_set[, 2:3])

# Fitting regression model
regressor = lm(formula = Profit ~ .,
               data = training_set)

# Printing summary of the regressor
summary(regressor)
# Var. Kategorikal akan muncul dalam variabel dummy
# R akan secara otomatis menghindari dummy var. trap dengan menghilangkan 1 variabel dummy

y_pred = predict(regressor, newdata = test_set)
y_pred

# Backward Elimination
regressor = lm(Profit ~ R.D.Spend + Administration + Marketing.Spend + State,
               data = training_set)
summary(regressor) # Eliminate State
regressor = lm(Profit ~ R.D.Spend + Administration + Marketing.Spend,
               data = training_set)
summary(regressor) # Eliminate Administration
regressor = lm(Profit ~ R.D.Spend + Marketing.Spend,
               data = training_set)
summary(regressor) # Eliminate Administration
regressor = lm(Profit ~ R.D.Spend,
               data = training_set)
summary(regressor) # Eliminate Marketing Spend