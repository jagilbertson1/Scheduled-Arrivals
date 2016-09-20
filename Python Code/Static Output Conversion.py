import os
import csv

outputName = "Static_Output.csv"
N = 15

# delete output file if exists
if os.path.exists(outputName):
    os.remove(outputName)

# create header
header = ['n','gamma','mu']
for i in range(1,N):
    header += ['x[' + str(i) + ']']
header += ['cost']

with open(outputName, "w+") as outputFile:
    writer = csv.writer(outputFile)
    writer.writerow(header)

with open("Static_Output.txt", "r") as txtFile:
    append = False    
    prev = ''
    
    for index, line in enumerate(txtFile):
        if (index > 0):
            if (append):
                line = prev + line
            
            if (line.split(sep = ",")[-1] == "\n"):
                append = True
                prev = line
        
            else:
                append = False
                items = [val.replace("array([","").replace("])","").split()[0] for val in line.split(sep = ",")]
            
                row = [float('nan')]*(N+3)
                
                row[0:len(items)-1] = [float(val) for val in items[0:len(items)-1]]
                row[-1] = float(items[-1])
                
                # write output    
                with open(outputName, "a+") as outputFile:
                    writer = csv.writer(outputFile)
                    writer.writerow(row)