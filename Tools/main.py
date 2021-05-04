f = open("Altbalaji.txt")
line2 = ""
c = 0
for line in f:
    c+=1
    line = str(c)+')    '+ line;
    line2 = line2+ line
print(line2)

f2 = open("Altbalaji_ok.txt", "a")
f2.write(line2)
f2.close()