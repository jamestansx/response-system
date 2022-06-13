function [tp, os, ts, tr] = evalPerf(T)
    num = T.num{1};
    den = T.den{1};
    [zeta, wn] = getZetaWn(num, den);
    [y,t,x] = step(T);

    tr = (t(findIndex(y, 0.9)) - t(findIndex(y, 0.1)))/wn;
    tp = pi / (wn*sqrt(1-zeta^2));
    os = exp(-(zeta*pi)/sqrt(1-zeta^2))*100;
    ts = 4 / (zeta*wn);

    fprintf(["T_p = ", num2str(tp), "\n"]);
    fprintf(["OS%% = ", num2str(os), "\n"]);
    fprintf(["T_s = ", num2str(ts), "\n"]);
    fprintf(["T_r = ", num2str(tr), "\n"]);

    function in = findIndex(y, t)
        diff = 0;
        in  = 1;
        for i = y'
            d = t - i;
            if d <= 0 break; end
            if diff == 0 || d < diff
                diff = d;
            end
            in = in + 1;
        end
    end
end
