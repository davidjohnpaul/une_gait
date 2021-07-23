% MIT License
%
% Copyright (c) 2021 Matthew Cooper, David Paul, Jelena Schmalz and Xenia Schmalz
%
% Permission is hereby granted, free of charge, to any person obtaining a copy
% of this software and associated documentation files (the "Software"), to deal
% in the Software without restriction, including without limitation the rights
% to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
% copies of the Software, and to permit persons to whom the Software is
% furnished to do so, subject to the following conditions:
%
% The above copyright notice and this permission notice shall be included in all
% copies or substantial portions of the Software.
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
% SOFTWARE.

% Makes figures to be used in the paper
% ../data/com_data_une.mat should be created by using convert_csv_to_matlab.py on the data available from https://doi.org/10.6084/m9.figshare.15041322.v2
% ../data/com_data_online_walk.mat should be created by using convert_csv_to_matlab on a csv created by get_com_data_online_walk.py

figure1 = figure('Name', 'Figure 1', 'NumberTitle', 'off');
ax1 = axes('Parent', figure1);
compare_smoothed(ax1, {'../data/com_data_une.mat', '../data/com_data_une.mat'}, {'UNE11', 'UNE11'}, {'9 km/hr', '9 km/hr'}, {0.03, 0.3});

figure2 = figure('Name', 'Figure 2', 'NumberTitle', 'off');
ax2 = axes('Parent', figure2);
compare_smoothed(ax2, {'../data/com_data_une.mat'}, {'UNE11'}, {'4 km/hr'}, {0.03});

figure3 = figure('Name', 'Figure 3', 'NumberTitle', 'off');
ax3 = axes('Parent', figure3);
compare_smoothed(ax3, {'../data/com_data_une.mat'}, {'UNE11'}, {'9 km/hr'}, {0.03});

figure4 = figure('Name', 'Figure 4', 'NumberTitle', 'off');
ax4 = axes('Parent', figure4);
add_linear_regression_solution_plot(ax4, 0.3, 1, 0, 0, 0, 0, 0, '../data/com_data_une.mat', 'UNE08', '8 km/hr');

% figure5 comes from R

% figure6 comes from R

figure7 = figure('Name', 'Figure 7', 'NumberTitle', 'off');
ax7 = axes('Parent', figure7);
add_linear_regression_solution_plot(ax7, 0.01, 0, 0, 0, 0, 0, 0, '../data/com_data_online_walk.mat', 'WBDS01', '0.67 m/s');

figure8 = figure('Name', 'Figure 8', 'NumberTitle', 'off');
ax8 = axes('Parent', figure8);
add_linear_regression_solution_plot(ax8, 0.3, 0, 0, 0, 0, 0, 0, '../data/com_data_online_walk.mat', 'WBDS11', '1.31 m/s');

figure9 = figure('Name', 'Figure 9', 'NumberTitle', 'off');
ax9 = axes('Parent', figure9);
compare_smoothed(ax9, {'../data/com_data_une.mat'}, {'UNE10'}, {'14 km/hr'}, {0.3});

figure10 = figure('Name', 'Figure 10', 'NumberTitle', 'off');
ax10 = axes('Parent', figure10);
add_linear_regression_solution_plot(ax10, 0.3, 0, 0, 0, 0, 0.1, 0.01, '../data/com_data_une.mat', 'UNE10', '14 km/hr');

figure11 = figure('Name', 'Figure 11', 'NumberTitle', 'off');
ax11 = axes('Parent', figure11);
add_linear_regression_solution_plot(ax11, 0.3, 1, 0, 1, 0, 0, 0, '../data/com_data_une.mat', 'UNE06', '7 km/hr');

figure12 = figure('Name', 'Figure 12', 'NumberTitle', 'off');
ax12 = axes('Parent', figure12);
compare_smoothed(ax12, {'../data/com_data_une.mat', '../data/com_data_une.mat', '../data/com_data_une.mat'}, {'UNE14', 'UNE08', 'UNE11'}, {'6 km/hr', '6 km/hr', '6 km/hr'}, {0.03, 0.03, 0.03});

figure13 = figure('Name', 'Figure 13', 'NumberTitle', 'off');
ax13 = axes('Parent', figure13);
compare_smoothed(ax13, {'../data/com_data_une.mat', '../data/com_data_une.mat'}, {'UNE02', 'UNE02'}, {'6 km/hr', '6 km/hr'}, {0.03, 0.3});
