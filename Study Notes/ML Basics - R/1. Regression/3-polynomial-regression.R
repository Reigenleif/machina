# Preprocessing
dataset = read.csv('Position_Salaries.csv')
dataset = dataset[2:3] # Mengambil kolom 2 sampai 3 saja

# Tidak dilakukan splitting karena data points terlalu sedikit

# Fitting linear & poly'al model
lin_reg = lm(formula = Salary ~ Level, 
               data = dataset)
dataset$Level2 = dataset$Level^2 # Adding new column based other columns
dataset$Level3 = dataset$Level^3
dataset$Level4 = dataset$Level^4
x_grid = seq(min(dataset$Level), max(dataset$Level), 0.1)
poly_reg = lm(formula = Salary ~ .,
              data = dataset)

# Visualizing the results
# install.packages('ggplot2')
library(ggplot2)

ggplot() +
  geom_point(aes( x = dataset$Level, y = dataset$Salary),
             colour = 'red') +
  geom_line(aes( x = dataset$Level, y = predict(lin_reg, newdata = dataset)),
            colour = 'blue') +
  geom_line(aes( x = dataset$Level, y = predict(poly_reg, newdata = data.frame(Level = x_grid,
                                                                               Level2 = x_grid^2,
                                                                               Level3 = x_grid^3,
                                                                               Level4 = x_grid^4))),
            colour = 'green') +
  ggtitle('Salary vs Position Level') +
  xlab('Position')
  ylab('Salary')

# Predicting new value with lin_reg
predict(lin_reg, data.frame(Level = 6.5))

# Predicting new value with poly_reg
predict(poly_reg, data.frame(Level = 6.5,
                            Level2 = 6.5^2,
                            Level3 = 6.5^3,
                            Level4 = 6.5^4))

# Summary
summary(poly_reg)
  
