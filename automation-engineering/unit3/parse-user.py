#!/usr/bin/python3

import csv;

with open('./users.csv', 'r') as fh:
    data = fh.readlines()

for ln in csv.reader(data):
    gen = ln[0]
    age = ln[2]
    loc = ln[3]
    print(f"Gender: {gen}, Age: {age}, Location: {loc}")


