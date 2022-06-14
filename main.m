function db = main (varargin)
    close all;

    db = cell();
    lastpart = 1;
    last = 1;

    % Default Transfer Function
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
        part0();
        part1(dre,im); 
        part2(re, dim); 
        part3(wn, z);
        part4(w, zeta);
    else
        for i = 1:length (varargin)
            switch varargin{i}
                case 0
                    part0();
                    continue;
                case 1
                    part1(dre,im); 
                    continue
                case 2
                    part2(re, dim); 
                    continue
                case 3
                    part3(wn, z); 
                    continue
                case 4
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
        f1 = figure;
        draw(T, 1);
        legend('s/(s^2 + s + 1)');
        title('Step Response of s/(s^2 + s + 1)');
        f2 = figure;
        pmap(T, 1);
    end

    function part1 (a,b)
        discription(1, "Changes on the Imaginary Part of the Poles");
        [db{1},f1,f2] = part(a, b, @setReIm);
        figure(f1);
        hold all;
        drawenv(db{1}{1,1});
        [str, i] = cLegend(b, '\omega_d');
        figure(f2);
        legend(str);
        str{i+1, 1} = "Envelope";
        figure(f1);
        legend(str);
        title("Step Response of Varying Imaginary Part of Poles");
        j = 1;
        for i = db{1}
            fprintf([num2str(j), ") ", num2str(b(j)), "\n"]);
            evalPerf(i{1});
            fprintf("***************\n");
            j = j + 1;
        end
    end

    function part2 (a, b)
        discription(2, "Changes on the Real Part of the Poles");
        [db{2},f1,f2] = part(a, b, @setReIm);
        str = cLegend(a, '\alpha');
        figure(f1);
        legend(str);
        figure(f2);
        legend(str);
        figure(f1);
        title("Step Response of Varying Real Part of Poles");
        j = 1;
        for i = db{2}
            fprintf([num2str(j), ") ", num2str(a(j)), "\n"]);
            D = i{1};
            n = D.num{1};
            d = D.den{1};
            evalPerf(D);
            [x, y] = getZetaWn(n, d);
            fprintf(['damping ratio = ', num2str(x), "\n"]);
            fprintf(['natural frequency = ', num2str(y), "\n"]);
            fprintf("***************\n");
            j = j + 1;
        end
    end
    
    function part3 (a, b)
        discription(3, "Changes on the damping ratio");
        str = cLegend(b, '\zeta');
        [db{3},f1,f2] = part(a, b, @setWnRatio);
        figure(f1);
        legend(str);
        figure(f2);
        legend(str);
        figure(f1);
        title('Step Response of Varying Damping Ratio, \zeta of system');
        j = 1;
        for i = db{3}
            fprintf([num2str(j), ") ", num2str(b(j)), "\n"]);
            evalPerf(i{1});
            fprintf("***************\n");
            j = j + 1;
        end
    end

    function part4 (a, b)
        discription(4, "Changes on the Natural Frequency");
        [db{4},f1,f2] = part(a, b, @setWnRatio);
        str = cLegend(a, '\omega_n');
        figure(f1);
        legend(str);
        figure(f2);
        legend(str);
        figure(f1);
        title('Step Response of Varying Natural Frequency, \omega_n of system');
        j = 1;
        for i = db{4}
            fprintf([num2str(j), ") ", num2str(a(j)), "\n"]);
            evalPerf(i{1});
            fprintf("***************\n");
            j = j + 1;
        end
    end

    function [D,f1,f2] = part(a, b, setFunc)
        if isscalar(a) const = a; j = b;
        else const = b; j = a;
        end
        
        D  = cell();
        f1 = figure;
        f2 = figure;

        in = 1;
        n = 1;

        for i = j
            if isscalar(a) [num, den] = setFunc(const, i);
            else [num, den] = setFunc(i, const);
            end

            T = initUnderdTf(num, den);
            figure(f1);
            hold all;
            draw(T, in);
            figure(f2);
            hold all;
            pmap(T, in);
            in = in + 1;

            D{n} = T;
            n = n + 1;
        end
    end
    
    function iter = citer(first, last, len)
        iter = first:(last-first)/(len-1):last;
    end
end

