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

% Performs two linear regressions, one with k and v as features and one
% with only k as features and v set to zero. Returns regression with best
% loss.
%
% Parameters are:
%   filename - The name of the file to load data from
%   person - The name of a person in the observation data set or "None"
%   speed - The name of the speed
%   fft_threshold - The FFT threshold to use
%
% Outputs:
%   v - The vector of fitted coefficients for v
%   k - The vector of fitted coeffecients for k
%   t - The vector of fitted coeffecients for t
%  z0 - The vector of fitted coeffecients for z0
function [k, v, t, z0] = fit_linear_regression(obs_filename, obs_person, obs_speed, fft_threshold)
    [ts, z, zt, ztt] = get_observation_data(obs_filename, obs_person, obs_speed, fft_threshold);
    t = [ts(1); ts(end)];
    z0 = [z(1); zt(1)];
    
    feature1 = -1 * zt;
    feature2 = -1 * zt.^2;
    feature3 = -1 * zt.^3;
    feature4 = -1 * z;
    feature5 = -1 * z.^2;
    feature6 = -1 * z.^3;
    response = transpose(ztt);
    
    % Regression using all features
    X = [feature1(:) feature2(:) feature3(:) feature4(:) feature5(:) feature6(:)];
    b_1 = regress(response, X);
    
    % Regression holding the v1 = v2 = v3 = 0.
    X = [feature4(:) feature5(:) feature6(:)];
    b_2 = regress(response, X);
    
    
    % Loss from fitting all coefficients
    v_1 = [b_1(1) b_1(2) b_1(3)];
    k_1 = [b_1(4) b_1(5) b_1(6)];
    [dzs_1, dts_1, solver] = solve_duffing(v_1, k_1, t, z0);
    if ~strcmp(solver, "")
        loss_1 = duffing_loss(z, zt, ztt, ts, dzs_1(:,1), dzs_1(:,2), dzs_1(:,3), dts_1);
    else
        loss_1 = realmax;
    end
    
    % Loss from regression holding v1=v2=v3=0 constant
    v_2 = [0 0 0];
    k_2 = [b_2(1) b_2(2) b_2(3)];
    [dzs_2, dts_2, solver] = solve_duffing(v_2, k_2, t, z0);
    if ~strcmp(solver, "")
        loss_2 = duffing_loss(z, zt, ztt, ts, dzs_2(:,1), dzs_2(:,2), dzs_2(:,3), dts_2);
    else
        loss_2 = realmax;
    end
    
    % Choose result which minimises loss
    if loss_1 < loss_2
        v = v_1;
        k = k_1;
    else
        v = v_2;
        k = k_2;
    end
end
