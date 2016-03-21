#!/usr/bin/env python

import pandas as pd
import numpy as np
from scipy.stats import poisson
from ProgressBar import Progress

pd.set_option('display.width', pd.util.terminal.get_terminal_size()[0])
pd.options.display.float_format = '{:.2f}'.format

def cost_none_to_schedule(k, mu, cost_wait):
    return(cost_wait * mu * k * (k + 1) / 2)

def erlang_cdf(a, k, mu):
    if (a > 0):
        return(poisson.sf(k = k - 1, mu = a / mu))
    else:
        return(0)

def erlang_conditional_mean(a, k, mu):
    if (a > 0):
        return(mu * k * erlang_cdf(a = a, k = k + 1, mu = mu) / erlang_cdf(a = a, k = k, mu = mu))
    else:
        return(0)

def trans_prob(a, k, j, mu):
    if (a == 0):
        return(int(j == k + 1))
    
    elif (a > 0 and k == 0):
        return(int(j == 1))
    
    elif (a > 0 and k >= 1 and j == 1):
        return(erlang_cdf(a = a, k = k, mu = mu))
    
    elif (a > 0 and k >= 1 and j >= 2 and j <= k):
        return(erlang_cdf(a = a, k = k - (j - 1), mu = mu) - erlang_cdf(a = a, k = k - (j - 1) + 1, mu = mu))

    elif (a > 0 and k >= 1 and j == (k + 1)):
        return(1 - erlang_cdf(a = a, k = 1, mu = mu))

    else:
        return(0)

def trans_cost(a, k, j, mu, cost_wait, cost_idle):
    if (a == 0):
        return(0)

    elif (a > 0 and k >= 0 and j == 1):
        return(cost_idle * a + erlang_conditional_mean(a = a, k = k, mu = mu) * (cost_wait * (k + 1) - 2 *
                                cost_idle) / 2)

    elif (a > 0 and k >= 1 and j >= 2 and j <= (k + 1)):
        return(cost_wait * a * (j - 1) + cost_wait * erlang_conditional_mean(a = a, k = k - (j - 1), mu = mu) * (k -
                                (j - 1) + 1) / 2)

def cost_total(a, k, mu, cost_wait, cost_idle, next_cost):
    cost = 0
    
    for j in range(1, k + 2):
        cost += trans_prob(a = a, k = k, j = j, mu = mu) * (trans_cost(a = a, k = k, j = j, mu = mu,
                                cost_wait = cost_wait, cost_idle = cost_idle) + next_cost[j])
    
    return(cost)

N = 10
mu = 1
cost_wait = 1
cost_idle = 1

max_a = 10
incr_a = 0.01
seq_a = np.arange(0, max_a, incr_a) + incr_a

cost_matrix = pd.DataFrame(data = [[np.nan for k in range(N + 1)] for j in range(N + 1)])

chosen_a = pd.DataFrame(data = [[np.nan for k in range(N)] for j in range(N)], index = [(j + 1) for j in range(N)])

for k in range(N + 1):
    cost_matrix.loc[0, k] = cost_none_to_schedule(k = k, mu = mu, cost_wait = cost_wait)

print('')

bar = Progress(N * (N + 1) / 2)
count = 0
                                                    
for n in range(1, N + 1):
    for k in range(N - n + 1):
        min_cost = cost_total(a = 0, k = k, mu = mu, cost_wait = cost_wait, cost_idle = cost_idle,
                                  next_cost = cost_matrix.loc[n - 1])
        min_a = 0

        for a in seq_a:
            new_cost = cost_total(a = a, k = k, mu = mu, cost_wait = cost_wait, cost_idle = cost_idle,
                                  next_cost = cost_matrix.loc[n - 1])

            if (new_cost < min_cost):
                min_cost = new_cost
                min_a = a

        cost_matrix.loc[n, k] = min_cost
        chosen_a.loc[n, k] = min_a
        
        count += 1
        bar.update(count)

bar.close()

print('\nParameters are: {0:d} patients with mu = {1:d}, waiting cost = {2:d} and idle cost = {3:d}'.format(N, mu,
                                  cost_wait, cost_idle))

print('\nCost matrix of number to be scheduled by current queue size:\n')

print(cost_matrix.replace(np.nan, '', regex = True))

print('\nChosen a values to obtain minimum:\n')

print(chosen_a.replace(np.nan, '', regex = True))

print('')