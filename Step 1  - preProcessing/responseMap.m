
function correct = responseMap(event, actimage)

actImage = find(actimage);

if ~isempty(actImage)
    switch actImage
        case 1
            imageMat = [4 3 2 1];
        case 2
            imageMat = [3 4 1 2];
        case 3
            imageMat = [1 2 4 3];
        case 4
            imageMat = [2 1 3 4];
    end
    correct = find(imageMat == find(event));
else
    correct = [];
end





