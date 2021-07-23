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

% Find and classify the fixed points of the Duffing Equation in the form
%   k1*z + k2*z^2 + k3*z^3 +  v1*z' + v2*z'^2 + v3*'^3 + z'' = 0
%
% Return a call array with up to 5 entries, where each entry contains the value of the fixed point and its classification
function points = fixed_points(k, v)
  points = cell(5, 1);
  % Find the values (roots) of z where z' = z'' = 0
  % The v coefficients can be ignored as z' = 0 by definition.
  zs = roots([-fliplr(k) 0]);
  % There will be up to 5 real or complex roots for the equation
  for i = 1:length(zs)
    z = zs(i);
    % Add and classify real points
      if isreal(z)
        points{i} = {z classify_fixed_point(k, v, z)};
      end
  end
end
