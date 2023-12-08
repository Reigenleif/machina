# Preprocessing
dataset = read.csv('Salary_Data.csv')

# install.packages('caTools')
library(caTools)
set.seed(123)
split = sample.split(dataset$YearsExperience, SplitRatio = .8)
training_set = subset(dataset, split == TRUE)
test_set = subset(dataset, split == FALSE)

training_set[, 2:3] = scale(training_set[, 2:3]) 
test_set[, 2:3] = scale(test_set[, 2:3])

# Fitting linear model
regressor = lm(formula = Salary ~ YearsExperience, 
               data = training_set,
               )
# fugsi lm (linear model) menerima argumen formula dan data
# formula menunjukkan model linear dari data yang diinginkan, merupakan proporsionalitas
# ruas kiri ~ merupakan dep. var dan ruas kanan ~ merupakan ind. var
# data berisi matriks dari data

# Printing summary of the regressor
summary(regressor)
# Untuk memahami summary dari lm regressor, silakan belajar statistika

# Predicting test set result
y_pred = predict(regressor, newdata = test_set)
# predict menerima 2 argumen, argumen pertama adalah regressor dan argumen newdata yang 
# merupakan test set baru (harus dengan header yang sama dengan training set)

# Visualizing results
install.packages('ggplot2')
library(ggplot2)
ggplot() + 
  geom_point(aes(x = training_set$YearsExperience, y = training_set$Salary),
             colour = 'red') +
  geom_line(aes(x = training_set$YearsExperience, y = predict(regressor, newdata = training_set)),
            colour = 'blue') + 
  ggtitle('Salary vs Years of Experience') +
  xlab('Years of Experience (Yr)') + 
  ylab('Salary')
            

