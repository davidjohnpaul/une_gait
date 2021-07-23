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

% Get the observation data for the given person at the given speed recording, performing any required filtering and differentiation
%
% Inputs are the filename, person name, speed, and fft threshold to use
% Outputs are the timestamp, height, velocity and acceleration of each opservation, as well as the height, velocity, and acceleration of the best-fitting plane
function [ts, z, zt, ztt, plane_z,  plane_zt, plane_ztt] = get_observation_data(filename, person, speed, fft_threshold)
        data = load(filename, '-mat', 'com_data');
        person_data = data.com_data(person);
        speed_data = person_data(speed);

        ts = speed_data(:, 1)';
        z = speed_data(:, 4)';
        
        dt = ts(2) - ts(1);
        z = fft_filter(z, fft_threshold);
        zt = diff(z) / dt;
        ztt = diff(z, 2) / (dt^2);
        plane_dt = dt;
        plane_z = z;
        plane_zt = (plane_z(2:end) - plane_z(1:(end - 1)))/plane_dt;
        plane_ztt = (plane_zt(2:end) - plane_zt(1:(end - 1)))/plane_dt;
        % Get all observation vectors to have same length as ztt
        ts = ts(1:(end - 2));
        z = z(1:(end - 2));
        zt = zt(1:(end - 1));
        plane_z = plane_z(1:(end - 2));
        plane_zt = plane_zt(1:(end - 1));
end
