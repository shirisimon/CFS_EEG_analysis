function [ d2Mat ] = ReshapeData( d3Mat )

d2Mat = [];
for i=1:size(d3Mat,3)
    current = d3Mat(:,:,i);
    d2Mat = [d2Mat; reshape(current ,1,size(current ,2)*size(current ,1))];
end

end

