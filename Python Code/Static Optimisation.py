import numpy as np
import math
import scipy.optimize as optimize
import pandas as pd

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

def solver(n, gamma, mu = 1):
    if (n == 1):
        cost = phi([], gamma, mu)
        return (cost)
    
    else:        
        bnds = ()
        for i in range(n - 1):
            bnds += ((0, None),)
    
        res = optimize.minimize(fun = phi, x0 = [0]*(n - 1), args = (gamma, mu), bounds = bnds)
    
        return (res)

#"""
mu = 1

nVec = np.arange(2, 7, 1)
gammaVec = np.arange(0.05, 1, 0.05)

data = pd.DataFrame(np.append(1,nVec), columns = ["n"])

for gamma in gammaVec:
    data["gamma = " + str(gamma)] = pd.Series()
    
    res = solver(1, gamma, mu)
    data.loc[0, "gamma = " + str(gamma)] = res
    
    for i, n in enumerate(nVec):
        res = solver(n, gamma, mu)
        data.loc[i + 1, "gamma = " + str(gamma)] = res.fun

print(data)
#"""

"""
n = 2
mu = 1

gamVec = np.arange(1, 0, -0.05)

data = pd.DataFrame(gamVec, columns = ["$\gamma$"])

data["$x_{1}$"] = pd.Series()
data["$x_{2}$"] = pd.Series()
data["$\phi (\mathbf{x})$"] = pd.Series()

for gamma in gamVec:
    res = solver(n, gamma, mu)
    
    if (res.success):
        data.loc[data["$\gamma$"] == gamma, ["$x_{1}$", "$x_{2}$", "$\phi (\mathbf{x})$"]] = \
                                                                                [res.x[0], res.x[1], res.fun]

print(data)

print(data.to_latex(index = False, escape = False, float_format = lambda x: '%.2f' % x))
"""