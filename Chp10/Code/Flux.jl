
using Flux
using Flux.Tracker

f(x) = 3x^2 + 2x + 1
df(x) = Tracker.gradient(f, x; nest = true)[1]
df(3)

d2f(x) = Tracker.gradient(df, x; nest = true)[1]
d2f(3)

f(W, b, x) = W*x + b
Tracker.gradient(f, 2, 3, 4)

W = param(2) # 2.0 (tracked)
b = param(3) # 3.0 (tracked)

f(x) = W * x + b

grads = Tracker.gradient(() -> f(4), params(W, b))

(grads[W] , grads[b]) 

W = rand(2, 5)
b = rand(2)

predict(x) = W*x .+ b

function loss(x, y)
  ŷ = predict(x)
  sum((y .- ŷ).^2)
end

x, y = rand(5), rand(2) # Dummy data
loss(x, y) # ~ 3

W = param(W)
b = param(b)

gs = Tracker.gradient(() -> loss(x, y), params(W, b))

gs[W]

gs[b]

using Flux.Tracker: update!

D = gs[W]
update!(W, -0.1D)


loss(x, y) 

using Flux, Flux.Data.MNIST, Statistics
using Flux: onehotbatch, onecold, crossentropy, throttle
using Base.Iterators: repeated

# Classify MNIST digits with a simple multi-layer-perceptron

imgs = MNIST.images()

# Stack images into one large batch
X = hcat(float.(reshape.(imgs, :))...)

labels = MNIST.labels()

# One-hot-encode the labels
Y = onehotbatch(labels, 0:9)

m = Chain(
  Dense(28^2, 32, relu),
  Dense(32, 10),
  softmax)

loss(x, y) = crossentropy(m(x), y)
accuracy(x, y) = mean(onecold(m(x)) .== onecold(y))

dataset = repeated((X, Y), 200)
evalcb = () -> @show(loss(X, Y))
opt = ADAM()

Flux.train!(loss, params(m), dataset, opt, cb = throttle(evalcb, 10))
accuracy(X, Y)

# Test set accuracy
tX = hcat(float.(reshape.(MNIST.images(:test), :))...) |> gpu
tY = onehotbatch(MNIST.labels(:test), 0:9) |> gpu

accuracy(tX, tY)

using Metalhead
using Metalhead: classify
using Images

# Switch to dataset images and classify the known (1000) images
cd(homedir()*"/PacktPub/Datasets/Images")
vgg = VGG19()

img01 = load("elephant.jpg")
classify(vgg, img01)

using Unicode

img02 = load("harry.jpg")
animal = uppercase(classify(vgg, img02))
println("Meow, I am a $animal perhaps ???'")

animal_types = Metalhead.labels(vgg)
animal_types[1:5]

# How sure are we?
#
probs = Metalhead.forward(vgg, img02)
sort(probs)[996:1000]

perm = sortperm(probs)
animal_types[perm[1000]]

animal_types[perm[999]]   # <= This is a breed of DOG. sorry Harry.

animal_types[287:288]    # If not a cat -- why not one of these ?

pwd(); include("KnetJL/mnist-mlp/mlp.jl")

MLP.main("--epochs 15")

using Knet, Images
cd(Knet.dir("examples"))
pwd()

include("mnist-mlp/mlp.jl")
MLP.main("--epochs 15")

xtrn,ytrn,xtst,ytst = MLP.mnist()
map(summary,(xtrn,ytrn,xtst,ytst))

using Images
mnistview(x,i) = Images.colorview(Gray,permutedims(x[:,:,1,i],(2,1)))

hcat([mnistview(xtst,i) for i=1:5]...)

ytst[1:5]'

include("fashion-mnist/fashion-mnist.jl")

FashionMNIST.main("--epochs 15")

include("../data/fashion-mnist.jl")

xtrn,ytrn,xtst,ytst = fmnist()
map(maximum,(xtrn,ytrn,xtst,ytst))

fmnistview(x,i) = Images.colorview(Gray,permutedims(x[:,:,1,i],(2,1)))
hcat([fmnistview(xtst,i) for i=1:10]...)

ytst[1:10]'

xtst


