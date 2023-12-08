# Data preprocessing
dataset = read.csv('Social_Network_Ads.csv')

library(caTools) # Import statement in R
set.seed(123)
split = sample.split(dataset$Purchased, SplitRatio = .75)
training_set = subset(dataset, split == TRUE)
test_set = subset(dataset, split == FALSE)

training_set[, 1:2] = scale(training_set[, 1:2]) 
test_set[, 1:2] = scale(test_set[, 1:2])

# Fit the classification model
library(class)
y_pred = knn(train = training_set[,-3],
                 test = test_set[,-3],
                 cl = training_set[,3],
                 k = 5) # Tidak ada classifier object, knn langsung mengembalikan y_pred

# Confusion matrix
cm = table(test_set[,3],y_pred)
print(cm)

# Visualization
library(ElemStatLearn)

# color area prediction
set = training_set
X1 = seq(min(set[,1]) - 1, max(set[,1]) + 1, by=0.01)
X2 = seq(min(set[,2]) - 1, max(set[,2]) + 1, by=0.01)

grid_set = expand.grid(X1,X2)
colnames(grid_set) = c("Age", "EstimatedSalary")
y_set = knn(train = training_set[,-3],
            cl = training_set[,3],
            test = grid_set[,1:2],
            k = 5)



# Membentuk plot
plot(set[,-3],
     main = "Purchase (KNN)",
     xlab = "Age",
     ylab = "Estimated Salary",
     xlim = range(X1),
     ylim = range(X2))

contour(X1,X2,
        matrix(as.numeric(y_set),
               length(X1),
               length(X2)),
        add=TRUE)

points(grid_set, pch='.', col = ifelse(y_set == 1,'springgreen4', 'tomato')) # BG
points(set, pch=21, bg = ifelse(set[,3] == 1,'green4', 'red3')) # Points






