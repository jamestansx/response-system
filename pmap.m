function pmap(T, in) 
    kkk = {'d', 'o', '*', 'x'};
    pzmap(T, kkk{1, in});
    set(gca, 'xaxislocation', 'origin');
    set(gca, 'yaxislocation', 'origin');
    axp = get(gca, 'position');
    xs = axp(1);
    xe = axp(1) + axp(3) + 0.05;
    ys = axp(2);
    ye = axp(2) + axp(4) + 0.05;
    annotation('arrow', axp(1)+axp(3)*[1 1], [ys ye]);
    annotation('arrow', [xs xe], axp(2)+axp(4)/2*[1 1]);
    legend off;
    box off;
    grid on;
end

