function db = main (varargin)
    close all;

    global db last fignum; 
    db = {};
    lastpart = 1;
    last = 1;
    fignum = 1;

    % s = 1 / (s^2 + s + 1)
    dnum = [1];
    dden = [1 1 1];
    [zeta, wn] = getZetaWn(dnum, dden);
    dre = -zeta*wn;
    dim = wn*sqrt(1-zeta^2);

    len = 4;
    re = citer(dre,dre+0.4, len);
    im = citer(dim,dim+0.4, len);
    z  = citer(zeta-0.4, zeta+0.3, len);
    w  = citer(wn, wn+1, len);


    if nargin == 0 
        part0;
        part1(dre,im); 
        part2(re, dim); 
        part3(wn, z);
        part4(w, zeta);
    else
        for i = 1:length (varargin)
            switch varargin{i}
                case 0
                    part0;
                    continue;
                case 1
                    part1(dre,im); 
                    continue
                case 2
                    lastpart = 2;
                    part2(re, dim); 
                    continue
                case 3
                    lastpart = 3;
                    part3(wn, z); 
                    continue
                case 4
                    lastpart = 4;
                    part4(w, zeta);
                    continue
                otherwise
                    continue
            end
        end
    end

    function part0
        fprintf("Default parameter:\n");
        fprintf(["Damping ratio: ", num2str(zeta), "\n"]);
        fprintf(["Natural Frequency: ", num2str(wn), "\n"]);
        fprintf(["Complex pole: ", num2str(dre), " + ", "j", num2str(dim), "\n"]);
        T = initUnderdTf(dnum, dden);
        figure(fignum);
        draw(T, 1);
        fignum = fignum + 1;
        legend('s/(s^2 + s + 1)');
        title('Step Response of s/(s^2 + s + 1)');
        figure(fignum);
        pmap(T, 1);
        fignum = fignum + 1;
    end

    function part1 (a,b)
        discription(1, "Changes on the Imaginary Part of the Poles");
        T = part(a, b, @setReIm);
        drawenv(db{4,1});
        [str, i] = cLegend(b, '\omega_d');
        figure(fignum - 1);
        legend(str);
        str{i+1, 1} = "Envelope";
        figure(fignum - 2);
        legend(str);
        title("Step Response of Varying Imaginary Part of Poles");
        for i = 1:1:4
            fprintf([num2str(i), ") ", num2str(b(i)), "\n"]);
            evalPerf(db{i,1});
            fprintf("***************\n");
        end
    end

    function part2 (a, b)
        discription(2, "Changes on the Real Part of the Poles");
        T = part(a, b, @setReIm);
        str = cLegend(a, '\alpha');
        legend(str);
        figure(fignum - 1);
        legend(str);
        figure(fignum - 2);
        title("Step Response of Varying Real Part of Poles");
        for i = 1:1:4
            fprintf([num2str(i), ") ", num2str(a(i)), "\n"]);
            D = db{i,2};
            n = D.num{1};
            d = D.den{1};
            evalPerf(D);
            [x, y] = getZetaWn(n, d);
            fprintf(['damping ratio = ', num2str(x), "\n"]);
            fprintf(['natural frequency = ', num2str(y), "\n"]);
            fprintf("***************\n");
        end
    end
    
    function part3 (a, b)
        discription(3, "Changes on the damping ratio");
        str = cLegend(b, '\zeta');
        T = part(a, b, @setWnRatio);
        legend(str);
        figure(fignum - 1);
        legend(str);
        figure(fignum - 2);
        title('Step Response of Varying Damping Ratio, \zeta of system');
        for i = 1:1:4
            fprintf([num2str(i), ") ", num2str(b(i)), "\n"]);
            evalPerf(db{i,3});
            fprintf("***************\n");
        end
    end

    function part4 (a, b)
        discription(4, "Changes on the Natural Frequency");
        T = part(a, b, @setWnRatio);
        str = cLegend(a, '\omega_n');
        legend(str);
        figure(fignum - 1);
        legend(str);
        figure(fignum - 2);
        title('Step Response of Varying Natural Frequency, \omega_n of system');
        for i = 1:1:4
            fprintf([num2str(i), ") ", num2str(a(i)), "\n"]);
            evalPerf(db{i,4});
            fprintf("***************\n");
        end
    end

    function T = part(a, b, setFunc)
        if isscalar(a) const = a; j = b;
        else const = b; j = a;
        end

        figure(fignum);
        hold all;

        in = 1;
        disp(j);
        for i = j
            if isscalar(a) [num, den] = setFunc(const, i);
            else [num, den] = setFunc(i, const);
            end

            T = initUnderdTf(num, den);
            draw(T, in);
            figure(fignum + 1);
            hold all;
            pmap(T, in);
            figure(fignum);
            in = in + 1;

            db{last, lastpart} = T;
            last = last + 1;
        end

        parthandler();
    end

    function parthandler
        last = 1;
        lastpart = lastpart + 1;
        fignum = fignum + 2;
    end
    
    function iter = citer(first, last, len)
        iter = first:(last-first)/(len-1):last;
    end
end

