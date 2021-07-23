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

% Fixed point classification types
classdef FixedPointClassification < uint32
  enumeration
    CentreSpiral(1),
    SaddlePoint(2)
    StableSpiral(3),
    UnstableSpiral(4),
    StableProperNode(5),
    UnstableProperNode(6),
    StableImproperNode(7),
    UnstableImproperNode(8),
    Other(9)
  end
  methods
    % Human-friendly label
    function label = label(fp)
      labels = {
        "Centre"
        "Saddle Point"
        "Stable Spiral"
        "Unstable Spiral"
        "Stable Proper Node"
        "Unstable Proper Node"
        "Stable Improper Node"
        "Unstable Improper Node"
        "Other"
      };
      label = labels{fp};
    end
  end
end
