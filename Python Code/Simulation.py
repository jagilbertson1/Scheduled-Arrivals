import csv
import numpy as np

mu = 1
N = 15
gamma = 0.5

numRuns = 100000

# store total waiting time, total service time, total idle time and total cost for each run
totalWaitTime = [0]*numRuns
totalServiceTime = [0] * numRuns
totalIdleTime = [0]*numRuns
totalCost = [0]*numRuns

# read in static interarrival times
with open("Static_Output.csv", 'r') as outputFile:
    reader = csv.reader(outputFile)
    for row in reader:
        if (row[0:3] == [str(N),str(gamma),str(mu)]):
            interarrival = [float(val) for val in row[3:N+2]]
            ExpCost = float(row[-1])
            break

# convert to arrival time of all N customers
arrivalTime = np.append(0, np.cumsum(interarrival))

# generate service time of all N customers (for all runs)
serviceTime = np.random.exponential(scale = mu, size = (numRuns,N))

for run in range(numRuns):
    # calculate time service starts and time service ends for each customer
    serviceStart = [0]*N
    serviceEnd = [0]*N

    # first customer
    serviceStart[0] = arrivalTime[0]
    serviceEnd[0] = serviceStart[0] + serviceTime[run][0]

    # all other customers
    for i in range(1, N):
        serviceStart[i] = max(arrivalTime[i], serviceEnd[i - 1])
        serviceEnd[i] = serviceStart[i] + serviceTime[run][i]

    # calculate waiting time of each customer
    waitingTime = [0]*N

    for i in range(N):
        waitingTime[i] = serviceStart[i] - arrivalTime[i]

    # calculate total waiting time and total service time
    totalWaitTime[run] = sum(waitingTime)
    totalServiceTime[run] = serviceEnd[N - 1]

    # calculate total idle time
    totalIdleTime[run] = totalServiceTime[run] - sum(serviceTime[run])
    
    # calculate total cost
    totalCost[run] = gamma * totalServiceTime[run] + (1 - gamma) * totalWaitTime[run]

print('Expected Cost is ' + str(ExpCost))
print('Mean Cost is ' + str(np.mean(totalCost)))