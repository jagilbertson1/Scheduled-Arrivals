import numpy as np
from scipy.stats import poisson
import scipy.optimize as optimize

import os
from multiprocessing import Pool

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
    # set a to zero if try negative a in optimisation code
    if (a < 0):
        a = 0
    
    internal = 0
    for j in range(1, k + 2):
        internal += transProb(a, k, j, mu) * (transCost(a, k, j, gamma, mu) +
                                                                    optimalCost(n - 1, j, gamma, mu, computedDict)[0])
    
    return internal

def optimalCost(n, k, gamma, mu, computedDict):
    if (n, k, gamma, mu) in computedDict:
        return computedDict[(n, k, gamma, mu)][0], computedDict[(n, k, gamma, mu)][1], computedDict
    
    if (n == 0):
        newCost = (1 - gamma) * mu * k * (k - 1) / 2 + gamma * k * mu
        time = float('nan')
        
        computedDict[(n, k, gamma, mu)] = [newCost, time]      
        
        return newCost, time, computedDict
    
    elif (n >= 1 and k == 0):
        newCost = optimalCost(n - 1, 1, gamma, mu, computedDict)[0]
        time = 0        
        
        computedDict[(n, k, gamma, mu)] = [newCost, time]
        
        return newCost, time, computedDict
    
    elif (n >= 1 and k >= 1):              
        res = optimize.minimize(fun = cost, x0 = [0], args = (n, k, gamma, mu, computedDict), method = "L-BFGS-B",
                                bounds = ((0, None),))
        
        newCost = res.fun[0]
        time = res.x[0]
        
        computedDict[(n, k, gamma, mu)] = [newCost, time]
        
        return newCost, time, computedDict

def solver(args):
    N, gamma, mu, fname = args
    
    allResults = dict()
    
    for n in range(N + 1):
        for k in range(N - n + 1):
            singleCost, time, allResults = optimalCost(n, k, gamma, mu, allResults)

            # write output    
            with open(fname, "a+") as outputFile:
                outputFile.write(str(n) + "," + str(k) + "," + str(gamma) + "," + str(mu) + "," + str(time) + ","
                                                                    + str(singleCost) + "\n")

if __name__ == "__main__":
    mu = 1
    N = 20

    # output file name
    output = "Dynamic_Output.csv"

    gammaVec = np.arange(0.1, 1, 0.1)
    
    args = [(N, gamma, mu, output) for gamma in gammaVec]
    
    # run on two cores
    p = Pool(2)

    # delete output file if exists
    if os.path.exists(output):
        os.remove(output)

    # create header
    with open(output, "w+") as outputFile:
        outputFile.write("n,k,gamma,mu,a,cost\n")

    p.map(solver, args)