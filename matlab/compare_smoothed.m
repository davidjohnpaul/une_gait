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

% Plot the data from the corresponding files, people, speeds, and with the corresponding fft_threshold to the given axis
function compare_smoothed(axis, files, people, speeds, fft_thresholds)
    colours = {'g', 'r', 'b'};
    for i = 1:length(files)
        file = files{i};
        person = people{i};
        speed = speeds{i};
        fft_threshold = fft_thresholds{i};
        colour = colours{i};
        [~, z, zt, ztt, ~,  ~, ~] = get_observation_data(file, person, speed, fft_threshold);
        plot3(axis, z, zt, ztt, colour);
        xlabel(axis, 'z');
        ylabel(axis, 'zt');
        zlabel(axis, 'ztt');
        hold(axis, 'on');
    end
    if i > 0
        hold(axis, 'off');
    end
end



