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

% Performs a linear regression with only k as features for the five point version.
%
% Parameters are:
%   filename - The name of the file to load data from
%   person - The name of a person in the observation data set or "None"
%   speed - The name of the speed
%   fft_threshold - The FFT threshold to use
%
% Outputs:
%   k - The vector of fitted coeffecients for k
function [k, ts, z0] = fit_linear_regression_5(filename, person, speed, fft_threshold)
    [ts, z, zt, ztt] = get_observation_data(filename, person, speed, fft_threshold);
    z0 = [z(1); zt(1)];
    
    feature1 = -1 * z;
    feature2 = -1 * z.^2;
    feature3 = -1 * z.^3;
    feature4 = -1 * z.^4;
    feature5 = -1 * z.^5;
    
    response = transpose(ztt);
    
    % Regression 
    X = [feature1(:) feature2(:) feature3(:) feature4(:) feature5(:)];
    result = regress(response, X);
    k = [result(1) result(2) result(3) result(4) result(5)];
end
