# Preprocessing
dataset = read.csv('Position_Salaries.csv')
dataset = dataset[2:3] # Mengambil kolom 2 sampai 3 saja

# Tidak dilakukan splitting karena data points terlalu sedikit

# Fitting SVR Model
# install.packages('e1071')
library(e1071)
regressor = svm(formula = Salary ~ .,
                data = dataset)

# Visualizing the results
# install.packages('ggplot2')
library(ggplot2)

ggplot() +
  geom_point(aes( x = dataset$Level, y = dataset$Salary),
             colour = 'red') +
  geom_line(aes( x = dataset$Level, y = predict(regressor   
                                                , newdata = dataset)),
            colour = 'blue') +
  ggtitle('Salary vs Position Level') +
  xlab('Position') +
  ylab('Salary')

# Predicting new value with lin_reg
predict(regressor, data.frame(Level = 6.5))


# Summary
summary(regressor)

