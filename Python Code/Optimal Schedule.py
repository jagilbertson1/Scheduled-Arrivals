#!/usr/bin/env python

import pandas as pd
import numpy as np
from scipy.stats import poisson

pd.set_option('display.width', pd.util.terminal.get_terminal_size()[0])
pd.options.display.float_format = '{:.2f}'.format

def final_cost(i, mu, cost_wait):
    return(cost_wait * mu * i * (i + 1) / 2)

def prob_trans(a, i, j, mu):
    if (a == 0):
        return(int(j == i + 1))
    
    elif (i == 0):
        return(int(j == 1))
    
    elif (j == 1):
        return(poisson.sf(i - 1, a / mu))

    else:
        return(poisson.pmf(i - (j - 1), a / mu))

def cost_trans(a, i, j, mu, cost_wait, cost_idle):
    if (a == 0):
        return(0)

    elif (j == 1):
        return(cost_idle * a + (mu * i * (cost_wait * (i + 1) - 2 *
                  cost_idle) / 2) * poisson.sf(i, a / mu) / poisson.sf(i - 1,
                  a / mu))

    else:
        return(cost_wait * a * (j - 1) + (cost_wait * mu * (i - (j - 1)) *
                  (i - (j - 1) + 1) / 2) * poisson.sf(i - (j - 1), a / mu)
                  / poisson.sf(i - (j - 1) - 1, a / mu))

def cost(a, i, mu, cost_wait, cost_idle, cost_vec):
    return(sum([prob_trans(a, i, j, mu) * (cost_trans(a, i, j, mu, cost_wait,
             cost_idle) + cost_vec[j]) for j in range(1, i + 2)]))

N = 10
mu = 1
cost_wait = 1
cost_idle = 1

max_a = 10
incr_a = 0.01
seq_a = np.arange(0, max_a, incr_a) + incr_a

cost_matrix = pd.DataFrame(data = [[np.nan for i in range(N + 1)] for i in
                                    range(N + 1)])

for i in range(N + 1):
    cost_matrix.loc[0, i] = final_cost(i, mu, cost_wait)

chosen_a = pd.DataFrame(data = [[np.nan for i in range(N)] for i in range(N)],
                                index = [(i + 1) for i in range(N)])

for n in range(1, N + 1):
    for i in range(N - n + 1):
        min_cost = cost(0, i, mu, cost_wait, cost_idle,
                              cost_matrix.loc[n - 1])
        min_a = 0

        for a in seq_a:
            new_cost = cost(a, i, mu, cost_wait, cost_idle,
                                   cost_matrix.loc[n - 1])

            if (new_cost < min_cost):
                min_cost = new_cost
                min_a = a

        cost_matrix.loc[n, i] = min_cost
        chosen_a.loc[n, i] = min_a

print('\nCost matrix of number to be scheduled by current waiting number:\n')

print(cost_matrix.replace(np.nan, '', regex = True))

print('\nChosen a values to obtain minimum:\n')

print(chosen_a.replace(np.nan, '', regex = True))