# number of runs
N = 10^4

# param of X
r = 1

mu = 1
a = 1

results = data.frame(matrix(0, nrow = N, ncol = 2))
colnames(results) = c("X", "X + Y")

for (i in 1:N) {
  generate = rexp(n = r+1, rate = 1/mu)
  results[i,] = c(sum(generate) - generate[r+1], sum(generate))
}

# mean of X | (X <= a and X + Y > a)
sum(results[,1] * (results[,1] <= a) * (results[,2] > a)) / sum((results[,1] <= a) * (results[,2] > a))

# expectation of X | (X <= a and X + Y > a)
a * r / (r + 1)