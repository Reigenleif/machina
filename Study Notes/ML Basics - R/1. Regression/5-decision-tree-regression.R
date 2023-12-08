# Preprocessing
dataset = read.csv('Position_Salaries.csv')
dataset = dataset[2:3] # Mengambil kolom 2 sampai 3 saja

# Tidak dilakukan splitting karena data points terlalu sedikit

# Fitting Regression Tree Model
# install.packages('rpart')
library(rpart)
regressor = rpart(formula = Salary ~ .,
                  data = dataset,
                  control = rpart.control(minsplit=1))

# Visualizing the results
# install.packages('ggplot2')
library(ggplot2)

# Smoothen the curve
x_grid = seq(min(dataset$Level),max(dataset$Level),0.1)

ggplot() +
  geom_point(aes( x = dataset$Level, y = dataset$Salary),
             colour = 'red') +
  geom_line(aes( x = x_grid, y = predict(regressor   
                                                , newdata = data.frame(Level = x_grid))),
            colour = 'blue') +
  ggtitle('Salary vs Position Level') +
  xlab('Position') +
  ylab('Salary')

# Predicting new value with lin_reg
predict(regressor, data.frame(Level = 6.5))


# Summary
summary(regressor)

