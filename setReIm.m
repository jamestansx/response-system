function [num, den] = setReIm(re, im)
    a = 1;
    b = -a * (2 * re);
    c = a * (re + im * i) * (re - im * i);

    d = b/(2*sqrt(c));
    if d >= 1 
        e = ["The resulting response system is not an underdamped response: ", num2str(d)];
        error (e);
    end

    num = [c];
    den = [a b c];
end
