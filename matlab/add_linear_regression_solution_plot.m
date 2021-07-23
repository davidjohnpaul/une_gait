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

% Performs required linear regression and then plots the solution
% Parameters are:
%  axis - The axis to plot to
%  fft_threshold - the fft threshold to use when reading in data
%  plot_fixed_points - whether to plot the calculated fixed points for the curve
%  plot_fixed_points_5 - whether to plot 5 fixed points (true) or 3 (false)
%  vf - whether to plot a viscocity-force curve
%  bfp - whether to plot a best fitting plane
%  ei_max - If greater than zero, esplore initial conditions by adding up to this value to the initial z point
%  ei_step - If exploring initial conditions (see ei_max), explore this distance at each iteration
%  filename - The name of the file to load data from
%  person - The person to load data for from the file
%  speed - the speed of the person to use the data from
function add_linear_regression_solution_plot(axis, fft_threshold, plot_fixed_points, plot_fixed_points_5, vf, bfp, ei_max, ei_step, filename, person, speed)
  [k, v, t, z0] = fit_linear_regression(filename, person, speed, fft_threshold);
  add_solution_plot(axis, k, v, t, z0, fft_threshold, plot_fixed_points, plot_fixed_points_5, vf, bfp, filename, person, speed);
  if ei_max > 0
    z_min = z0(1);
    z_max = z_min + ei_max;
    z_step = ei_step;
    while z_min + z_step <= z_max
        z_min = z_min + z_step;
        z0 = [z_min; 0];
        add_solution_plot(axis, k, v, t, z0, fft_threshold, plot_fixed_points, plot_fixed_points_5, vf, bfp, filename, person, speed);
    end
  end
end
