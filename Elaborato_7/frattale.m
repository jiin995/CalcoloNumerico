function [time] = frattale(x, y, Z, maxIterations)
    % Setup
    t = tic();
    [X,Y]=meshgrid(x,y);

    %C=X+1i*Y;
    C=-0.4+i*0.6;
    Z=X+i*Y;
    for k=1:maxIterations
        Z=Z.^2+C;
        W=exp(-abs(Z));
    end

    % Show
    time = toc( t );
    colormap(jet);
    pcolor(W);
    shading flat;
    axis('square','equal','off');
    title( sprintf( 'Generato in %1.3f secs ',time) )
end

