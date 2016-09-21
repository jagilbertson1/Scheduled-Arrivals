import os
import csv
import numpy as np

mu = 1
N = 15
gamma = 0.5

numRuns = 10**6

outputName = "Simulation_Output.csv"

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
    
    # arrival time for first customer in dynamic schedule
    arrivalTime[1,run,0] = interarrivalDynamic[(N, 0)]
    
    # calculate time service starts and time service ends for first customer
    for sch in range(2):
        serviceStart[sch,run,0] = arrivalTime[sch,run,0]
        serviceEnd[sch,run,0] = serviceStart[sch,run,0] + serviceTime[run,0]

    for i in range(1, N):
        # arrival time for customer i in dynamic schedule
        arrivalTime[1,run,i] = arrivalTime[1,run,i-1] + \
                                    interarrivalDynamic[(N-i, sum(serviceEnd[1,run,0:i] > arrivalTime[1,run,i-1]))]        
        
        # calculate time service starts and time service ends
        for sch in range(2):
            serviceStart[sch,run,i] = max(arrivalTime[sch,run,i], serviceEnd[sch,run,i-1])
            serviceEnd[sch,run,i] = serviceStart[sch,run,i] + serviceTime[run,i]

    # calculate waiting time of each customer
    for i in range(N):
        for sch in range(2):
            waitingTime[sch,run,i] = serviceStart[sch,run,i] - arrivalTime[sch,run,i]

    # calculate total waiting time and total service time
    for sch in range(2):
        totalWaitTime[sch,run] = sum(waitingTime[sch,run])
        totalServiceTime[sch,run] = serviceEnd[sch,run,N-1]

    # calculate total idle time
    for sch in range(2):
        totalIdleTime[sch,run] = totalServiceTime[sch,run] - sum(serviceTime[run])
    
    # calculate total cost
    for sch in range(2):
        totalCost[sch,run] = gamma * totalServiceTime[sch,run] + (1 - gamma) * totalWaitTime[sch,run]

print('For Static Schedule:')
print('Expected Cost is ' + str(cost[0]))
print('Mean Cost is ' + str(np.mean(totalCost[0])))

print('')

print('For Dynamic Schedule:')
print('Expected Cost is ' + str(cost[1]))
print('Mean Cost is ' + str(np.mean(totalCost[1])))

# delete output file if exists
if os.path.exists(outputName):
    os.remove(outputName)

# create header
header = ['schedule','run']

for i in range(1, N + 1):
    header += ['AT[' + str(i) + ']']

for i in range(1, N + 1):
    header += ['WT[' + str(i) + ']']

header += ['TWT', 'TST', 'TIT', 'Cost']

with open(outputName, "w+") as outputFile:
    writer = csv.writer(outputFile)
    writer.writerow(header)

for sch in range(2):
    for run in range(numRuns):
        if (sch == 0):
            row = ['static']
        else:
            row = ['dynamic']
        
        row += [run]        
        
        row += [arrivalTime[sch,run,i] for i in range(N)]
        row += [waitingTime[sch,run,i] for i in range(N)]

        row += [totalWaitTime[sch,run], totalServiceTime[sch,run], totalIdleTime[sch,run], totalCost[sch,run]]
        
        # write output    
        with open(outputName, "a+") as outputFile:
            writer = csv.writer(outputFile)
            writer.writerow(row)

"""
Potential commands

np.mean(totalCost[0] - totalCost[1])
np.median(totalCost[0] - totalCost[1])
np.percentile(totalCost[0] - totalCost[1], [25,75])
np.mean(totalCost[1]>cost[1])
np.array([np.mean([int(waitingTime[0,run,n] == 0) - int(waitingTime[1,run,n] == 0) for run in range(numRuns)]) for n in range(N)])
np.array([np.mean([waitingTime[0,run,n] - waitingTime[1,run,n] == 0 for run in range(numRuns)]) for n in range(N)])
interarrivalStatic - np.mean(np.diff(arrivalTime[1]), axis = 0)
"""