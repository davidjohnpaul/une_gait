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

% Classify the fixed point at z
%
% k and v are coefficients of the Duffing Equation (either 3 or 5 of them)
%
% Result if a FixedPointClassification
function [classification] = classify_fixed_point(k, v, z)
  if size(k) == 5
    % Base decision on sign of Jacobian
    J = k(1)+ 2*k(2)*z +3*k(3)*z^2 + 4*k(4)*z^3 + 5*k(5)*z^4;
    if J > 0
      classification = FixedPointClassification.CentreSpiral;
    elseif J < 0
      classification = FixedPointClassification.SaddlePoint;
    else
      classification = FixedPointClassification.Other;
    end
  else
    % Base decision on eigenvalues
    m = k(1) + 2*k(2)*z + 3*k(3)*z^2;
    D = v(1)^2 - 4*m;
        
    if D == 0
      % Eigenvalues equal and real
      if v(1) > 0
        classification = FixedPointClassification.StableProperNode;
      elseif v(1) < 0
        classification = FixedPointClassification.UnstableProperNode;
      else
        classification = FixedPointClassification.Other;
      end
    elseif D > 0
      % Eigenvalues different and real
      if m < 0
        classification = FixedPointClassification.SaddlePoint;
      elseif m == 0 || v(1) == 0
        classification = FixedPointClassification.Other;
      elseif v(1) > 0
        classification = FixedPointClassification.StableImproperNode;
      else
        classification = FixedPointClassification.UnstableProperNode;
      end
    else
      % Eigenvalues complex
      if v(1) == 0
        classification = FixedPointClassification.CentreSpiral;
      elseif v(1) > 0
        classification = FixedPointClassification.StableSpiral;
      else
        classification = FixedPointClassification.UnstableSpiral;
      end
    end
  end
