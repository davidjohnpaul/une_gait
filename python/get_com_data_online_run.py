#!/usr/bin/env python3

# MIT License
#
# Copyright (c) 2021 Matthew Cooper, David Paul, Jelena Schmalz and Xenia Schmalz
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

import csv
import math
import sys

# It is expected this file will be used with the dataset available from http://doi.org/10.6084/m9.figshare.4543435, using a command similar to the following:
# python3 get_com_data_online_run.py RDBS*runT*markers.txt

# It will use the information from RBDSinfo.csv to determine the participant's speed and then calculate the centre of mass by averaging the position of the ASIS markers. It will also subtract the minimum heel height from the vertical component.

# Output will be stored in com_data_online_run.csv

def process(filename):
    participant = filename[:7]
    print("{}\t{}".format(filename, participant))

    with open('RBDSinfo.csv') as metadata:
        speed = "Unknown"
        reader = csv.DictReader(metadata)
        for row in reader:
            if row['FileName'] == filename:
                speed = row['GaitSpeed(m/s)']
                if speed == '--' or speed == '-':
                    speed = 'Balance'
                else:
                    speed += ' m/s'

    with open('output.csv', 'a') as output:
        writer = csv.writer(output)
        count = 0

        min_heel_y = 1000000
        with open(filename) as csvfile:
            reader = csv.DictReader(csvfile, delimiter = '\t')
            for row in reader:
                l_heel_y = float(row['L.Heel.BottomY'])
                r_heel_y = float(row['R.Heel.BottomY'])
                min_heel_y = min(min_heel_y, l_heel_y, r_heel_y)


        with open(filename) as csvfile:
            reader = csv.DictReader(csvfile, delimiter = '\t')
            row_count = 0
            for row in reader:
                row_count = (row_count + 1) % 2
                if row_count % 2 == 0:
                    continue
                time = float(row['Time'])

                x1 = float(row['R.ASISX'])
                x2 = float(row['L.ASISX'])
                x3 = 0 #float(row['R.PSISX'])
                x4 = 0 #float(row['L.PSISX'])
                x = (x1 + x2 + x3 + x4) / 2

                y1 = float(row['R.ASISY'])
                y2 = float(row['L.ASISY'])
                y3 = 0 #float(row['R.PSISY'])
                y4 = 0 #float(row['L.PSISY'])
                y = (y1 + y2 + y3 + y4) / 2 - min_heel_y

                z1 = float(row['R.ASISZ'])
                z2 = float(row['L.ASISZ'])
                z3 = 0 #float(row['R.PSISZ'])
                z4 = 0 #float(row['L.PSISZ'])
                z = (z1 + z2 + z3 + z4) / 2
 
                # Convert from mm to m
                x = x / 1000
                y = y / 1000
                z = z / 1000

                # Swap y and z to match expected coordinate system
                fields = [participant, speed, time, x, z, y]
                if not (math.isnan(time) or math.isnan(x) or math.isnan(y) or math.isnan(z)):
                    writer.writerow(fields)
                count += 1


def main(argv):
    with open('com_data_online_run.csv', 'w') as output:
        output.write("Participant,Speed,Time,X,Y,Z\n");

    for filename in argv[1:]:
        process(filename)

if __name__ == "__main__":
    main(sys.argv)
