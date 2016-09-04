from scipy.stats import poisson
import scipy.optimize as optimize

import functools

#@functools.lru_cache()
def cdf(a, r, mu):
    if (a > 0):
        return poisson.sf(r - 1, a / mu)
        
    elif (a == 0):
        return 0

#@functools.lru_cache()
def transProb(a, k, j, mu):
    if (k == 0):
        return int(j == 1)
    
    elif (k >= 1 and j == 1):
        return cdf(a, k, mu)
    
    elif (k >= 1 and 2 <= j and j <= k):
        return cdf(a, k - j + 1, mu) - cdf(a, k - j + 2, mu)
    
    elif (k >= 1 and j == (k + 1)):
        return 1 - cdf(a, 1, mu)
    
    else:
        return 0

#@functools.lru_cache()
def condExp(a, r, mu):
    if (a > 0):
        return mu * r * cdf(a, r + 1, mu) / cdf(a, r, mu)
    
    elif (a == 0):
        return 0

#@functools.lru_cache()
def transCost(a, k, j, gamma, mu):
    if (k == 0 or k == 1):
        return gamma * a
    
    elif (k >= 2 and j == 1):
        return (1 - gamma) * condExp(a, k, mu) * (k - 1) / 2 + gamma * a
    
    elif (k >= 2 and 2 <= j and j <= k):
        return (1 - gamma) * (a * (j - 2) + condExp(a, k - (j - 1), mu) * (k - (j - 2)) / 2) + gamma * a
    
    elif (k >= 2 and j == (k + 1)):
        return (1 - gamma) * a * (j - 2) + gamma * a

#@functools.lru_cache()
def cost(a, n, k, gamma, mu):
    internal = 0
    for j in range(1, k + 2):
        internal += transProb(a, k, j, mu) * (transCost(a, k, j, gamma, mu) + optimalCost(n - 1, j, gamma, mu))
    
    return internal
  
#@functools.lru_cache()  
def optimalCost(n, k, gamma, mu):
    if (n == 0):
        return (1 - gamma) * mu * k * (k - 1) / 2 + gamma * k * mu
    
    elif (n >= 1 and k == 0):
        return optimalCost(n - 1, 1, gamma, mu)
    
    elif (n >= 1 and k >= 1):
        res = optimize.minimize(fun = cost, x0 = [0], args = (n, k, gamma, mu), bounds = ((0, None),))
        return res.fun[0]

mu = 1
gamma = 0.5

n = 4
k = 1

print(optimalCost(n, k, gamma, mu))