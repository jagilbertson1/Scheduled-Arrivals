import numpy as np

def prob(i, j, x, mu):
    if (i == 1 and j == 0):
        return(1)
    
    elif (i >= 2 and j == 0):        
        value = 0
        for k in range(1, i):
            sum1 = 0
            for l in range(k):
                sum1 += ((mu * x[i-1])^l / l!) * np.exp(-mu * x[i-1])
            
            value += prob(i - 1, k - 1, x, mu) * (1 - sum1)
            
        return(value)
    
    elif (i >= 2 && j >= 1 && j <= i - 1):
        value = 0
        for k in range(i - j):
            value += prob(i - 1, j + k - 1, x, mu) * ((mu * x[i-1])^k / k!) * np.exp(-mu * x[i-1])
        
        return(value)
    
    else:
        return(0)

def waitTime(i, x, mu):
    if (i == 1):
        return(0)
    
    elif (i >= 2):
        value = 0
        for j in range(1, i):
            value += (j / mu) * prob(i, j, x, mu)
        
        return (value)

def phi(gamma, x, mu):
    n = len(x) + 1
    
    value = 0
    for i in range(1, n + 1):
        value += (1 - gamma) * waitTime(i, x, mu)
    
    for i in range(1, n):
        value += gamma * x[i]