classdef PagedTiffAdapterWithMskReduced < ImageAdapter
    properties
        Filename
        Info
        Page
        Mask
    end
    methods
        function obj = PagedTiffAdapterWithMskReduced(filename, page,Msk)
            obj.Filename = filename;
            obj.Info = imfinfo(filename);
            obj.Page = page;
            obj.ImageSize = [obj.Info(page).Height obj.Info(page).Width];
            obj.Mask = Msk;
        end
        function result = readRegion(obj, start, count)
            if sum(sum(obj.Mask(start(1): start(1) + count(1) - 1,...
                    start(2): start(2) + count(2) - 1)))>0
                result = imread(obj.Filename,'Index',obj.Page,...
                    'Info',obj.Info,'PixelRegion', ...
                    {[start(1), start(1) + count(1) - 1], ...
                    [start(2), start(2) + count(2) - 1]});
            else
                result = zeros(count);
            end
        end
        function result = close(obj) %#ok
        end
    end
end