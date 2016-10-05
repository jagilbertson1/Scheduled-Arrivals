import numpy as np
import math
import scipy.optimize as optimize

import os
from multiprocessing import Pool

# distribution of number in system
def probSystem(i, j, x, mu):
    if (i == 1 and j == 0):
        return 1
    
    elif (i >= 2 and j == 0):        
        value = 0
        for k in range(1, i):
            internal = 0
            for l in range(k):
                internal += (x[i-2]**l / (mu**l *
                            math.factorial(l))) * np.exp(-x[i-2] /
                            mu)
            
            value += probSystem(i - 1, k - 1, x, mu) * (1 -
                            internal)
            
        return value
    
    


    elif (i >= 2 and j >= 1):
        value = 0
        for k in range(i - j):
            value += probSystem(i - 1, j + k - 1, x, mu) * \
                        (x[i-2]**k / (mu**k *
                        math.factorial(k))) * np.exp(-x[i-2] / mu)
        
        return value

# expected waiting time
def waitTime(i, x, mu):
    if (i == 1):
        return (0)
    
    elif (i >= 2):
        value = 0
        for j in range(1, i):
            value += (j * mu) * probSystem(i, j, x, mu)
        
        return value

# objective function
def phi(x, gamma, mu):
    # if any x is negative during optimisation, set to zero
    for i in range(len(x)):
        if (x[i] < 0):
            x[i] = 0
    
    n = len(x) + 1    
    value = 0
    
    for i in range(1, n + 1):
        value += (1 - gamma) * waitTime(i, x, mu)
    
    for i in range(1, n):
        value += gamma * x[i-1]
    
    value += gamma * waitTime(n, x, mu) + gamma * mu
    
    return value





# function to find optimal solution
def solver(args):
    n, gamma, mu, fname = args    
    
    # find bounds
    bnds = ()
    for i in range(n - 1):
        bnds += ((0, None),)
    
    # minimise
    res = optimize.minimize(fun = phi, x0 = [0]*(n - 1),
            args = (gamma, mu), method = "L-BFGS-B", bounds = bnds)
 
    # write output    
    with open(fname, "a+") as outputFile:
        outputFile.write(str(n) + "," + str(gamma) + "," + str(mu) +
                "," + repr(res.x) + "," + str(res.fun) + "\n")

if __name__ == "__main__":
    mu = 1
    
    # output file name
    output = "Static_Output.txt"

    nVec = np.arange(2, 16, 1)
    gammaVec = np.arange(0.1, 1, 0.1)  

    args = [(n, gamma, mu, output) for n in nVec
                for gamma in gammaVec]

    # run on 12 cores
    p = Pool(12)

    # delete output file if exists
    if os.path.exists(output):
        os.remove(output)

    # create header
    with open(output, "w+") as outputFile:
        outputFile.write("n,gamma,mu,x,cost\n")

    p.map(solver, args)