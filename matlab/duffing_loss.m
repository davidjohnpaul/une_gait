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

% Scaled loss between the observed data (z, zt, ztt, ts) and Duffing Equation output (dz, dzt, dztt, dts)
function [loss] = duffing_loss(z, zt, ztt, ts, dz, dzt, dztt, dts)
    % Use interpolation to get observation values at the calculated timestamps
    interp_z = interp1(ts, z, dts, 'spline');
    interp_zt = interp1(ts, zt, dts, 'spline');
    interp_ztt = interp1(ts, ztt, dts, 'spline');
    % Scale based on difference between max and min to avoid differences in mangnitudes
    scaled_z = max(z) - min(z);
    scaled_zt = max(zt) - min(zt);
    scaled_ztt = max(ztt) - min(ztt);
    loss = sqrt(sum(((interp_z - dz) / scaled_z).^2  + ((interp_zt - dzt) / scaled_zt).^2 + ((interp_ztt - dztt) / scaled_ztt).^2)) / length(dts);
end
