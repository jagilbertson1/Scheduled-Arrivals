def cdf(a, r, mu):
    if (a > 0):
        internal = 0
        for i in range(r):
            internal += 

def transProb(a, k, j, mu):
    if (k == 0):
        return (int(j == 1))
    
    elif (k >= 1 and j == 1):
        return (cdf(a, k, mu))
    
    elif (k >= 1 and 2 <= j and j <= k):
        return (cdf(a, k - j + 1, mu) - cdf(a, k - j + 2, mu))
    
    elif (k >= 1 and j == (k + 1)):
        return (1 - cdf(a, 1, mu))
    
    else:
        return (0)

def condExp(a, r, mu):
    if (a > 0):
        return (mu * r * cdf(a, r + 1, mu) / cdf(a, r, mu))
    
    elif (a == 0):
        return (0)

def transCost(a, k, j, gamma, mu):
    if (k == 0 or k == 1):
        return (gamma * a)
    
    elif (k >= 2 and j == 1):
        return ((1 - gamma) * condExp(a, k, mu) * (k - 1) / 2 + gamma * a)
    
    elif (k >= 2 and 2 <= j and j <= k):
        return ((1 - gamma) * (a * (j - 2) + condExp(a, k - (j - 1), mu) * (k - (j - 2)) / 2) + gamma * a)
    
    elif (k >= 2 and j == (k + 1)):
        return ((1 - gamma) * a * (j - 2) + gamma * a)