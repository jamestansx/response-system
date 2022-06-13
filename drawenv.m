function drawenv(T)
    num = T.num{1};
    den = T.den{1};
    w0 = sqrt(num);
    zeta = den(2)/(2*w0);
    lim = [xlim, ylim];
    y = @(t) 1 + (exp(-zeta*w0*t))/sqrt(1-zeta^2);
    fplot(y, lim, "--", "LineWidth", 2);
end


