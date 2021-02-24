function mkdirj(s)
if ~exist(s,'dir')
    mkdir(s)
end
end