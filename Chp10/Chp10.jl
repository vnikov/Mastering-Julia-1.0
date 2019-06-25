
cd(homedir()*"/PacktPub/Chp10")
const Chp10 = pwd()

using Loess, Plots
gr()

x = 10 .* rand(50)
y = 0.1*x .* sin.(x) .+ 0.2 * rand(50)
model = loess(x, y);

u = collect(minimum(x):0.1:maximum(x));
v = Loess.predict(model, u);

p = scatter(x,y)
plot!(p,u,v)

using LossFunctions

L2DistLoss()

true_targets = [  1,  0, -2, 1, 1.5] ;
pred_outputs = [0.5,  2, -1, 1, 2];

value(L2DistLoss(), true_targets, pred_outputs)
loss = L2DistLoss()

hcat(value(loss, true_targets, pred_outputs),
     deriv(loss, true_targets, pred_outputs), 
     deriv2(loss,true_targets, pred_outputs))'

A = rand(3,4)

B = rand(3,4)

W = [2,1,3,2];

v1 = value(L2DistLoss(), A, B, AvgMode.WeightedSum(W))
v2 = value(L2DistLoss(), A, B, AvgMode.WeightedMean(W))
round.([v1, v2], digits=4)

deriv(L2DistLoss(), A, B)'

deriv2(L2DistLoss(), A, B)'

using RDatasets, Clustering

# Fully qualify as Metalhead (below) as dataset function
iris = RDatasets.dataset("datasets", "iris")
iris[1:5,:]

features = Matrix(iris[:,[1,2,3,4]])'
result   = kmeans( features, 3)

fieldnames(KmeansResult)
# [length(features[i,:]) for i in 1:3]

length(result.assignments) == size(iris)[1]

result.iterations, result.converged, result.totalcost

result.assignments'

using Plots; gr()
scatter(features[1,:], features[2,:], features[4,:], color = result.assignments)

scatter(features[1,:], features[2,:], features[4,:], color = result.assignments)

results = [kmeans( features, i) for i = 2:6]
for i in 1:length(results)
    println(i+1, " => ", results[i].totalcost)
end

result2.iterations, result2.converged, result2.totalcost

labels = iris[:, 5];
plt = Gadfly.plot(x=Y[:,1], y=Y[:,2], color=labels)

using DecisionTree
using Random, Statistics

# Create a random dataset
Random.seed!(systime())
X = sort(5 * rand(80))
XX = reshape(X, 80, 1)
y = X .* sin.(X)
y[1:5:end] += 3 * (0.5 .- rand(16))
;

# Fit regression model
regr_1 = DecisionTreeRegressor()
regr_2 = DecisionTreeRegressor(pruning_purity_threshold=0.05)
regr_3 = RandomForestRegressor(n_trees=20)
DecisionTree.fit!(regr_1, XX, y)
DecisionTree.fit!(regr_2, XX, y)
DecisionTree.fit!(regr_3, XX, y)
;

# Predict
X_test = 0:0.01:5.0
y_1 = DecisionTree.predict(regr_1, hcat(X_test))
y_2 = DecisionTree.predict(regr_2, hcat(X_test))
y_3 = DecisionTree.predict(regr_3, hcat(X_test))
;

using Plots
gr()
Plots.scatter(X, y, label="data", color="lightblue", legend=:bottomleft)
Plots.plot!(X_test, y_1, color="black", label="no pruning", linewidth=3)
Plots.plot!(X_test, y_2, color="red", label="pruning threshold = 0.05", linewidth=3)
Plots.plot!(X_test, y_3, color="blue", label="Random Forest Classifier", linewidth=3)
Plots.title!("Decision Tree Regression")



