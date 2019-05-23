function der = oregonator(t, y)
    q = 9*10^(-5) ;
    e = 10^(-2) ;
    g = 2.5*10^(-5) ;
    f = 0.8;
    Y1 = (q*y(2)-y(1)*y(2)+y(1)*(1-y(1)))/e;
    Y2 = (-q*y(2)-y(1)*y(2)+f*y(3))/g;
    Y3 = y(1)-y(3);
    der = [Y1;Y2;Y3];
    
end
