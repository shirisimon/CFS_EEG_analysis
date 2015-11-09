function bins = genereateBins(range, size, step)

if nargin == 0
    range = [-500 1500];
    size = 50;
end
s = range(1):step:range(2)-size;
e = range(1)+size:step:range(2);

bins = [s' e'];

end