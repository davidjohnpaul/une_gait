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

% Function to solve system and plot results.
%
% Parameters are:
%   axis - The axis to plot to
%   k - A vector of coefficients of the Duffing Equation
%   v - A vector of coefficients of the Duffing Equation
%   t - A vector defining the range of time values on which to solve the equation. That is [t0 t1].
%   z0 - A vector of the initial values [z0 zt0] where zt is z'.
%   fft_threshold - The FFT threshold to use
%   plot_fixed_points - Binary flag to enable/disable plotting of fixed points
%   plot_fixed_points_5 - Binary flag to enable/disable 5 fixed points
%   vf - Binary flag to enable/disable viscosity/force curve
%   bfp - Binary flag to enable/disable best-fitting plane
%   filename - The file to load data from
%   person - The name of a person in the observation data set or "None"
%   speed - The name of a set of observations (generally labeled by speed)
function add_solution_plot(axis, k, v, t, z0, fft_threshold, plot_fixed_points, plot_fixed_points_5, vf, bfp, filename, person, speed)
  [zs, dts, solver] = solve_duffing(v, k, t, z0);

  % Plot the observation data if selected.
  loss_text = "Loss = N/A";
  if person ~= "None"
    [ts, z, zt, ztt, plane_z, plane_zt, plane_ztt] = get_observation_data(filename, person, speed, fft_threshold); 
    plot3(axis, z, zt, ztt, '-r', 'DisplayName', 'Observed', 'LineWidth', 1);
    hold(axis, 'on');
    plot3(axis, z(1:20:end), zt(1:20:end), ztt(1:20:end), 'r>', 'DisplayName', 'Direction', 'MarkerFaceColor', 'r', 'MarkerSize', 3);
    if ~strcmp(solver, "")
      % The loss can only be calculated if the solution is valid
      loss = duffing_loss(z, zt, ztt, ts, zs(:,1), zs(:,2), zs(:,3), dts);
      loss_text = sprintf("Loss = %0.5g", loss);
    end
  end

  % Plot the fixed points of the Duffing Equation under the current coefficient configuration, if fixed point display is enabled.
  centre = 0;
  if plot_fixed_points || vf
    if person ~= "None" && plot_fixed_points_5
      % Calculate the five fixed points, if necessary
      [fixed_k, ~, ~] = fit_linear_regression_5(obs_filename, obs_person, obs_speed, g, c, fft_threshold);
    else
      fixed_k = k;
    end
    points = fixed_points(fixed_k, v);

    for i = 1:length(points)
      if not(isempty(points{i}))
        point = points{i};
        % Each fixed points is at (z,0,0) as by definition the derivatives must be zero.
        zf = point{1};
        ztf = 0;
        zttf = 0;

        classification = point{2};
        if classification == FixedPointClassification.CentreSpiral
          centre = zf;
        end

        if plot_fixed_points
          plot3(axis, zf, ztf, zttf, 'r*', 'DisplayName', 'Fixed Point');
          % The initial space avoids overlapping the label and point
          label = sprintf(' %s at z=%f', classification.label(), zf);
          text(axis, zf, ztf, zttf, label);
          disp(label);
        end
      end
    end
    hold(axis, 'on');
  end

  if ~strcmp(solver, "")
    % If the Duffing Equation could be solved within integration tolerances then show the results
    display = strcat('z=',num2str(z0(1)));
    plot3(axis, zs(:,1), zs(:,2), zs(:,3), 'b', 'DisplayName', display, 'LineWidth', 2);
    xlabel(axis, 'z');
    ylabel(axis, 'z_t');
    zlabel(axis, 'z_{tt}');
    hold(axis, 'on');
  end

  % Display viscosity and force plot, if required
  if vf && exist('z', 'var')
    % If we have a fixed centre point, determine v and f
    xdata = [z; zt; ztt];
    ydata = 0.*(ts(1, :));
    viscosity_force_model = @(x,xdata)...
      xdata(3,:)+...
      x(1).*xdata(2,:)+...
      (x(4)*centre*centre).*(xdata(1,:)-centre)-...
      x(4).*(xdata(1,:)-centre).^3-...
      x(2).*(cos(x(3).*ts(1, :)));
    lb = [0 0 0 0];  % Values must be non-negative
    ub = [];  % No upper bounds
    viscosity_force_omega_k = [2 5 sqrt(abs(k(3)))*centre abs(k(3))];  % Initial estimates
    viscosity_force_omega_k = lsqcurvefit(viscosity_force_model, viscosity_force_omega_k, xdata, ydata, lb, ub)
        
    [zsvf, tsvf, solvervf, ~] = solve_duffing_viscosity_force(viscosity_force_omega_k(1), viscosity_force_omega_k(2), viscosity_force_omega_k(3), viscosity_force_omega_k(4), centre, z0, t);

    if ~strcmp(solvervf, "")
      % If the Duffing Equation could be solved within integration tolerances then show the results
      display = strcat('z=',num2str(z0(1)),' vf');
      plot3(axis, zsvf(:, 1), zsvf(:, 2), zsvf(:, 3), 'g', 'DisplayName', display, 'LineWidth', 2);  % Use the newly-calculated values
      hold(axis, 'on');
      loss_vf = duffing_loss(z, zt, ztt, ts, zsvf(:,1), zsvf(:,2), zsvf(:,3), tsvf);  % Use the newly-calculated values
      vf_loss_text = sprintf("\nLoss vf = %0.5g", loss_vf);
      loss_text = loss_text + vf_loss_text;
    end
  end

  % Display best-fitting plane, if required
  if bfp && exist('z', 'var')
    display = strcat('z=',num2str(z0(1)),' plane');
    plot3(axis, plane_z, plane_zt, plane_ztt, 'c', 'DisplayName', display, 'LineWidth', 2);
    loss_plane = duffing_loss(z, zt, ztt, ts, plane_z, plane_zt, plane_ztt, ts);
    plane_loss_text = sprintf('\nLoss plane = %0.5g', loss_plane);
    loss_text = loss_text + plane_loss_text;
  end

  % Output loss
  disp(loss_text);
end
