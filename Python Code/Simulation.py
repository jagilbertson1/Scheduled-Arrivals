import csv
import numpy as np
import pandas as pd

mu = 1
N = 15
gamma = 0.5

numRuns = 100000

# store arrival times, service start and end times for each customer, run and schedule
arrivalTime = np.zeros(shape = (2,numRuns,N))
serviceStart = np.zeros(shape = (2,numRuns,N))
serviceEnd = np.zeros(shape = (2,numRuns,N))

# store waiting time for each customer, run and schedule
waitingTime = np.zeros(shape = (2,numRuns,N))

# store total waiting time, total service time, total idle time and total cost for each run and schedule
totalWaitTime = np.zeros(shape = (2,numRuns))
totalServiceTime = np.zeros(shape = (2,numRuns))
totalIdleTime = np.zeros(shape = (2,numRuns))
totalCost = np.zeros(shape = (2,numRuns))

# expected cost of each schedule
cost = np.zeros(shape = 2)

# read in static interarrival times
with open("Static_Output.csv", 'r') as outputFile:
    reader = csv.reader(outputFile)
    for row in reader:
        if (row[0:3] == [str(N),str(gamma),str(mu)]):
            interarrivalStatic = [float(val) for val in row[3:N+2]]
            cost[0] = float(row[-1])
            break

# read in dynamic interarrival times
interarrivalDynamic = dict()

with open("Dynamic_Output.csv", 'r') as outputFile:
    reader = csv.reader(outputFile)
    for row in reader:
        if (row[2] == str(gamma) and row[3] == str(mu)):
            if (int(row[0]) == N and int(row[1]) == 0):
                interarrivalDynamic[(int(row[0]), int(row[1]))] = float(row[4])
                cost[1] = float(row[5])
            
            elif (int(row[0]) + int(row[1]) <= N):
                interarrivalDynamic[(int(row[0]), int(row[1]))] = float(row[4])        
           
# generate service time of all N customers (for all runs)
serviceTime = np.random.exponential(scale = mu, size = (numRuns,N))

for run in range(numRuns):
    # calculate arrival time of all N customers for static schedule
    arrivalTime[0,run] = np.append(0, np.cumsum(interarrivalStatic))    
    
    # calculate time service starts and time service ends for each customer
    # first customer
    serviceStart[0,run,0] = arrivalTime[0,run,0]
    serviceEnd[0,run,0] = serviceStart[0,run,0] + serviceTime[run,0]

    # all other customers
    for i in range(1, N):
        serviceStart[0,run,i] = max(arrivalTime[0,run,i], serviceEnd[0,run,i-1])
        serviceEnd[0,run,i] = serviceStart[0,run,i] + serviceTime[run,i]

    # calculate waiting time of each customer
    for i in range(N):
        waitingTime[0,run,i] = serviceStart[0,run,i] - arrivalTime[0,run,i]

    # calculate total waiting time and total service time
    totalWaitTime[0,run] = sum(waitingTime[0,run])
    totalServiceTime[0,run] = serviceEnd[0,run,N-1]

    # calculate total idle time
    totalIdleTime[0,run] = totalServiceTime[0,run] - sum(serviceTime[run])
    
    # calculate total cost
    totalCost[0,run] = gamma * totalServiceTime[0,run] + (1 - gamma) * totalWaitTime[0,run]

print('Expected Cost is ' + str(cost[0]))
print('Mean Cost is ' + str(np.mean(totalCost[0])))