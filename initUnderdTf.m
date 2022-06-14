function T = initUnderdTf(num, den)
    if !isnumeric(num) || !isnumeric(den) error ("Input(s) must be numeric"); end
    if !isscalar(num) error ("Numerator must be scalar"); end
    if length(den) != 3 error ("Denominator should be of length: 3"); end
    zeta = den(2) / (2 * sqrt(den(3)));
    if zeta >= 1
        e = ["The resulting response system is not an underdamped response: ", num2str(zeta)];
        error (e);
    end

    T = tf(num, den);
end
