#!/usr/bin/python3

import csv;

with open('./users.csv', 'r') as fh:
    data = fh.readlines()

for ln in csv.reader(data):
    print(f"Line num: {ln}")


