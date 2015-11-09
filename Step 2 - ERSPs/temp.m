%% temp


function celllist = temp(celllist)
    if ~ischar(celllist{1})
        for i = 1:size(celllist,2)
            celllist{i} = num2str(celllist{i});
        end
    end
end

