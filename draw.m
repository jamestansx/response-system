function draw(D, index)
    kkk = {"-", "--", ":", "-."};
    [y,t,x] = step(D);
    plot(t,y, kkk{1,index});
    grid on;
end
