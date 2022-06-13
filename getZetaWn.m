function [zeta, wn] = getZetaWn(num, den)
    if !isscalar(num) error ("num should be scalar"); end

    wn = sqrt(num);
    zeta = den(2) / (2 * wn);
end
