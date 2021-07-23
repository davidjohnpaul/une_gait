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
import sys

# It is expected this file will be used with csv files like une_gait.csv in the dataset available from https://figshare.com/articles/dataset/Centre_of_Mass_position_for_participants_on_a_treadmill/15041322/2, using a command similar to the following:
# python3 convert_csv_to_matlab.py une_gait.csv

# The program will convert the data into a Matlab map and save it in a file with the same name, except .csv is replaced with the .mat extension

def main(filename):
    rows = []
    with open(filename, "r", newline="") as f:
        reader = csv.reader(f, delimiter=",", quotechar='"')
        next(reader)  # Skip header
        for row in reader:
            rows.append(row)

    # Write to MATLAB file data.m.
    with open(filename[:-4] + ".mat", "w") as f:
        f.write("com_data = {")
        for name, speed, t, x, y, z in rows:
            f.write("'{}',".format(name))
            f.write("'{}',".format(speed))
            f.write("{},".format(t))
            f.write("{},".format(x))
            f.write("{},".format(y))
            f.write("{};".format(z))

        f.write("};\n")

if __name__ == "__main__":
    for filename in sys.argv[1:]:
        main(filename)
