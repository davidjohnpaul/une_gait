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

% Solver for the form of the Duffing Equation defined as:
%  z'' + v1 * z' + v2 * z'^2 + v3 * z'^3 + k1 * z + k2 * z^2 + k3 * z^3 = 0
% where (conceptually):
%  z is the scalar height
%  z' is the scalar velocity
%  z'' is the scalar acceleration
%
% Currently uses the `ode15s` solver because the Duffing Equation can be 'stiff'.
%
% Outputs:
%  zs - z, z' and z'' at each timestep respectively.
%  ts - timestep values
%  solver - The numerical solution method used
%  abstol - The absolute error tolerance used with the specified solver
function [zs, ts, solver, abstol] = solve_duffing(v, k, t, z0)
  abstol = ProjectConstants.INITIAL_ABSOLOUTE_ERROR_TOLERANCE;
  solver = "";
    
  % Disable warnings to allow integration tolerances to be dynamically adjusted
  warning('off', 'MATLAB:ode15s:IntegrationTolNotMet');
    
  while abstol <= ProjectConstants.MAXIMUM_ABSOLUTE_ERROR_TOLERANCE
    lastwarn(''); % Clear last warning. Necessary for the logic below
    opts = odeset('Jacobian', @jacobian, 'RelTol', ProjectConstants.RELATIVE_ERROR_TOLERANCE, 'AbsTol', abstol);
        
    [x, y] = ode15s(@duffing, t, z0, opts);
        
    [~, msgID] = lastwarn;
    if ~strcmp(msgID, 'MATLAB:ode15s:IntegrationTolNotMet')
      solver = "ODE15S";
      break;
    else
      % Raise integration error tolerance
      abstol = abstol*ProjectConstants.ABSOLUTE_ERROR_TOLERANCE_STEP;
    end
  end
    
  warning('on', 'MATLAB:ode15s:IntegrationTolNotMet');
    
  if strcmp(solver, "")
    % Solving failed
    zs = [];
    ts = [];
  else
    % Derive z'' from the results
    ts = x;
    z = y(:,1);
    zt = y(:,2);
    ztt = -(v(1) * zt + v(2) * (zt.^2) + v(3) * (zt.^3) + k(1) * z + k(2) * (z.^2)  + k(3) * (z.^3));
    zs = [z zt ztt];
  end

  % Definition of the Duffing Equation as an system of implicit first order ODEs
  function dz = duffing(~,z)
    dz1 = z(2);
    dz2 = -(v(1) * z(2) + v(2) * z(2)^2 + v(3) * z(2)^3 + k(1) * z(1) + k(2) * z(1)^2 + k(3) * z(1)^3);
    dz = [dz1; dz2];
  end

  % Definition of the Jacobian matrix for the system of first order ODE form of the Duffing Equation.
  function j = jacobian(~,z)
    dz2dz1 = -k(1) - 2 * k(2) * z(1) - 3 * k(3) * z(1)^2;
    dz2dz2 = -v(1) - 2 * v(2) * z(2) - 3 * v(3) * z(2)^2;
    j = [0 1; dz2dz1 dz2dz2];
  end
end
