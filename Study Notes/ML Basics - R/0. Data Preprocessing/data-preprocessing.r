# Importing the dataset
dataset = read.csv('data.csv')

# Taking care of missing data
dataset$Age = ifelse(is.na(dataset$Age),
                     ave(dataset$Age, FUN = function(x) mean(x, na.rm = TRUE)),
                     dataset$Age)
dataset$Salary = ifelse(is.na(dataset$Salary),
                        ave(dataset$Salary, FUN = function(x) mean(x, na.rm = TRUE)),
                        dataset$Salary)
# tanda $ berarti mengambil nilai-nilai dalam kolom
# is.na(x) returns true if x is null (dalam R, null disebut NA)
# ave adalah fungsi untuk mengambil rataan dari kolom, ave menerima 2 parameter :
# kolom yang dirata-rata dan FUN, fungsi/cara merata-ratakan


# Encoding categorical data
dataset$Country = factor(dataset$Country,
                         levels = c('France', 'Spain', 'Germany'),
                         labels = c(1,2,3))
dataset$Purchased = factor(dataset$Purchased,
                           levels = c('Yes', 'No'),
                           labels = c(0,1))
# Factor adalah fungsi untuk mentransformasi nilai-nilai pada kolom sekaligus (labeling)
# Levels adalah parameter yang menerima vektor berisi nilai-nilai lama
# Labels adalah parameter yang menerima vektor berisi nilai-nilal baru

# Splitting dataset
library(caTools) # Import statement in R
set.seed(123)
split = sample.split(dataset$Purchased, SplitRatio = .8)
training_set = subset(dataset, split == TRUE)
test_set = subset(dataset, split == FALSE)

# split berisi baris yang masuk ke trainging & test set
# split-i bernilai TRUE jika baris ke-i masuk ke dalam training set dan sebaliknya

# Feature Scaling
training_set[, 2:3] = scale(training_set[, 2:3]) 
test_set[, 2:3] = scale(test_set[, 2:3])
# slicing dengan [:,:] sama seperti python







