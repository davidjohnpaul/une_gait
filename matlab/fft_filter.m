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

function output = fft_filter(x, threshold)
  X = fft(x - mean(x));
  Xrest = X(2:end);
  n = length(Xrest);
  if mod(n, 2) == 0
      X1 = Xrest(1:(n/2));
  else
      X1 = Xrest(1:((n+1)/2));
  end
  ii = find(abs(X1) < threshold*max(abs(X1)));
  X1(ii) = zeros(1, length(ii));
  if mod(n, 2) == 0
      Xfiltered = [0, X1, conj(fliplr(X1))];
  else
      Xfiltered = [0, X1, conj(fliplr(X1(1:(end - 1))))];
  end
  output = ifft(Xfiltered) + mean(x);
end
