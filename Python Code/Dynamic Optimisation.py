from scipy.stats import poisson
import scipy.optimize as optimize

def cdf(a, r, mu):
    if (a > 0):
        return poisson.sf(r - 1, a / mu)
        
    elif (a == 0):
        return 0

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

def condExp(a, r, mu):
    if (a > 0):
        return mu * r * cdf(a, r + 1, mu) / cdf(a, r, mu)
    
    elif (a == 0):
        return 0

def transCost(a, k, j, gamma, mu):
    if (k == 0 or k == 1):
        return gamma * a
    
    elif (k >= 2 and j == 1):
        return (1 - gamma) * condExp(a, k, mu) * (k - 1) / 2 + gamma * a
    
    elif (k >= 2 and 2 <= j and j <= k):
        return (1 - gamma) * (a * (j - 2) + condExp(a, k - (j - 1), mu) * (k - (j - 2)) / 2) + gamma * a
    
    elif (k >= 2 and j == (k + 1)):
        return (1 - gamma) * a * (j - 2) + gamma * a

def cost(a, n, k, gamma, mu, computedDict):
    internal = 0
    for j in range(1, k + 2):
        internal += transProb(a, k, j, mu) * (transCost(a, k, j, gamma, mu) +
                                                                    optimalCost(n - 1, j, gamma, mu, computedDict)[0])
    
    return internal

def optimalCost(n, k, gamma, mu, computedDict):
    if (n, k, gamma, mu) in computedDict:
        return computedDict[(n, k, gamma, mu)], computedDict
    
    if (n == 0):
        newCost = (1 - gamma) * mu * k * (k - 1) / 2 + gamma * k * mu
        computedDict[(n, k, gamma, mu)] = newCost       
        
        return newCost, computedDict
    
    elif (n >= 1 and k == 0):
        newCost = optimalCost(n - 1, 1, gamma, mu)
        computedDict[(n, k, gamma, mu)] = newCost
        
        return newCost, computedDict
    
    elif (n >= 1 and k >= 1):              
        res = optimize.minimize(fun = cost, x0 = [0], args = (n, k, gamma, mu, computedDict), bounds = ((0, None),))
        
        newCost = res.fun[0]
        computedDict[(n, k, gamma, mu)] = newCost
        
        return newCost, computedDict

if __name__ == "__main__":
    mu = 1
    N = 20

    gamma = 0.5

    allResults = dict()

    for n in range(N + 1):
        for k in range(1, N - n + 1):
            singleCost, allResults = optimalCost(n, k, gamma, mu, allResults)        
            
            print("For (n, k) = (" + str(n) + ", " + str(k) + "), cost: " + str(round(singleCost, 3)))