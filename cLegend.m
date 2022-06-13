function [str, i] = cLegend(b, s)
    str = {};
    for i = 1:1:length(b)
        str{i,1} = [s, " = ", num2str(b(i))];
    end
end
