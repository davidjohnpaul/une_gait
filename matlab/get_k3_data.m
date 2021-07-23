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

% Gets k3 Duffing coefficient for use in statistical analysis.
% com_data_une.mat should be created by using convert_csv_to_matlab.py on the data available from https://doi.org/10.6084/m9.figshare.15041322.v2
% com_data_online_walk.mat should be created by using convert_csv_to_matlab on a csv created by get_com_data_online_walk.py
% com_data_online_run.mat should be created by using convert_csv_to_matlab on a csv created by get_com_data_online_run.py

files = ["com_data_une.mat", "com_data_online_walk.mat", "com_data_online_run.mat"];

fft_threshold = 0.3;

output_file = sprintf('k3_data_with_fft_threshold_%0.2f.csv', fft_threshold);
output_file_id = fopen(output_file, 'w');
fprintf(output_file_id,'%s,%s,%s\n', 'Participant', 'Speed', 'Duff', 'Data');
for i = 1:length(files)
    file = files{i};
    load(file, '-mat', 'com_data');
    participants = keys(com_data);
    for p = 1:length(participants)
        participant = participants{p};
        participant_data = com_data(participant);
        participant_speeds = keys(participant_data);
        for s = 1:length(participant_speeds)
            participant_speed = participant_speeds{s};
            
            speed = -1;
            if strcmp(participant_speed, 'Balance') || strcmp(participant_speed, 'Standing')
                speed = 0;
            elseif contains(participant_speed, 'km/hr')
                split_speed = split(participant_speed);
                tmp_speed = split_speed(1);
                tmp_speed = str2double(tmp_speed);
                tmp_speed = tmp_speed * (1000/60)/60;
                speed = tmp_speed;
            elseif contains(participant_speed, 'm/s')
                split_speed = split(participant_speed);
                tmp_speed = split_speed(1);
                tmp_speed = str2double(tmp_speed);
                speed = tmp_speed;
            end
            
            if speed > 0
                try
                    [k, ~, ~, ~, ~] = fit_linear_regression(file, participant, participant_speed, fft_threshold);
                    k3 = (-1)*k(3);
                    dataset = "UNE";
                    if i > 1
                      dataset = "RD";
                    end

                    fprintf(output_file_id, '%s,%0.2f,%0.2f,%s\n', participant, speed, k3, dataset);
                catch ME
                    fprintf('Skipping %s,%0.2f: Not enough points\n', participant, speed);
                end
            end
        end
    end
end
fclose(output_file_id);
clear ME output_file output_file_id file files i k k3 p s participants participant_data participant_speed participant_speeds split_speed tmp_speed participant speed com_data fft_threshold dataset
