import os
import re

def getLines():
    sourcePath = os.getcwd() + "/source.txt"
    sourceFile = open(sourcePath,'r')
    sourceLines = sourceFile.readlines()
    sourceFile.close()
    return sourceLines

def printData(lines):
    for line in lines:
        try:
            email = re.compile(r'[a-z0-9]+[@]\w+[.]\w{3}').search(line).group()
        except:
            continue

        try:
            id = re.compile(r'\d{3}').search(line).group()
        except:
            continue

        print("the", id, "of", email, "is", "even" if int(id) % 2 ==0 else "odd","number")

printData(getLines())