import numpy as np
import math
import scipy.optimize as optimize
import pandas as pd

from multiprocessing import Pool

def probSystem(i, j, x, mu):
    if (i == 1 and j == 0):
        return (1)
    
    elif (i >= 2 and j == 0):        
        value = 0
        for k in range(1, i):
            internal = 0
            for l in range(k):
                internal += (x[i-2]**l / (mu**l * math.factorial(l))) * np.exp(-x[i-2] / mu)
            
            value += probSystem(i - 1, k - 1, x, mu) * (1 - internal)
            
        return (value)
    
    elif (i >= 2 and j >= 1):
        value = 0
        for k in range(i - j):
            value += probSystem(i - 1, j + k - 1, x, mu) * (x[i-2]**k / (mu**k * math.factorial(k))) * \
                                                            np.exp(-x[i-2] / mu)
        
        return (value)

def waitTime(i, x, mu):
    if (i == 1):
        return (0)
    
    elif (i >= 2):
        value = 0
        for j in range(1, i):
            value += (j * mu) * probSystem(i, j, x, mu)
        
        return (value)

def phi(x, gamma, mu):
    n = len(x) + 1    
    value = 0
    
    for i in range(1, n + 1):
        value += (1 - gamma) * waitTime(i, x, mu)
    
    for i in range(1, n):
        value += gamma * x[i-1]
    
    value += gamma * waitTime(n, x, mu) + gamma * mu
    
    return (value)

def solver(args):
    n, gamma, mu = args    
    
    bnds = ()
    for i in range(n - 1):
        bnds += ((0, None),)
    
    res = optimize.minimize(fun = phi, x0 = [0]*(n - 1), args = (gamma, mu), bounds = bnds)
    
    return {'n' : n, 'gamma' : gamma, 'mu' : mu, 'x' : res.x, 'cost' : res.fun}

mu = 1

nVec = np.arange(2, 20, 1)
gammaVec = np.arange(0.1, 1, 0.1)

args = [(n, gamma, mu) for n in nVec for gamma in gammaVec]

p = Pool(4)

print(p.map(solver, args))