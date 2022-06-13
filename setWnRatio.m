function [num, den] = setWnRatio(wn, zeta)
    if zeta <= 0 || zeta >= 1 
        e = ["Damping ratio should 0 < zeta < 1 ", ": ", num2str(zeta)];
        error (e);
    end
    num = wn^2;
    den = [1 2*wn*zeta num];
end

