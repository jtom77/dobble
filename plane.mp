beginfig(1);

    tracingonline := 1;
    N := 7;
    u := 1cm;

    def randomcolor = (uniformdeviate(1), uniformdeviate(1), uniformdeviate(1)) enddef;

    vardef sort_by_min(expr l)(suffix p) = 
        path swp;
        for i=0 upto l-1: 
            for j=i+1 upto l:
                if (ypart point 0 of p[i]) < (ypart point 0 of p[j]):
                    swp := p[i];
                    p[i] := p[j];
                    p[j] := swp;
                fi;
            endfor;
        endfor;
        p
    enddef;

    vardef build_line(expr d, offs) = 
        
        ii := 0;
        path pp[];
        pair r, q;
        pp[ii] := (0, offs);
        for i=0 upto N-1:
            q := point length(pp[ii]) of pp[ii] + d;
            r := (xpart q mod N, ypart q mod N);
            if q=r:
                pp[ii] := pp[ii]--r;
            else:
                ii := ii+1;
                pp[ii] := r;
            fi;
        endfor;
        pp := sort_by_min(ii-1)(pp);

        for i=0 upto ii:
            if odd i:
                pp[i] := reverse(pp[i]);
            fi
        endfor;

        path conn[];
        for i=0 upto ii-2:
            conn[i] := merge(pp[i], pp[i+1]);
        endfor;

        path qq;
        qq := pp[0] for i=1 upto ii-1: ..conn[i-1]..pp[i] endfor;

        qq
    enddef;

    vardef merge(expr p, q) =
        stretch := 6;
        pair d;

        if (length(p) > 0):
            d := stretch*unitvector(direction(length(p)) of p);
        else:
            d := -stretch*unitvector(direction 0 of q);
        fi;
        
        pair a,b;
        a := point length(p) of p;
        b := point 0 of q;
        
        a .. controls (a+d) and (b+d) .. b
    enddef;

    def drawit(expr p) = 
        draw p withpen pencircle scaled 4pt withcolor white;
        draw p withpen pencircle scaled 2pt withcolor randomcolor;
        draw point length(0) of p withcolor red withpen pencircle scaled 12pt;
    enddef;

    vardef drawpic(expr w) =

        path qq[];
        pair v;
        boolean rotate;
        rotate := false;
        v := (abs(xpart w), ypart w);
        if (xpart v < ypart v):
            v := (ypart v, xpart v);
            rotate := true;
        fi;

        for k=0 upto N-1:
            qq[k] := build_line(v, k);
        endfor;


        numeric min, max;
        min := 1000; max := 0;
        for k=0 upto N-1:
            if ypart(point 0 of qq[k]) < min:
                min := ypart point 0 of qq[k];
            fi;
            if ypart(point 0 of qq[k]) > min:
                max := ypart point 0 of qq[k];
            fi;
        endfor;
        pair inf; 
        inf := .5[(0,min),(0,max)] shifted (-5*unitvector(v));

        for k=0 upto N-1:
            % qq[k] := inf -- qq[k];
            if xpart w<0:
                qq[k] := qq[k] xscaled -1 shifted(N-1,0);
            fi;
            if rotate:
                qq[k] := qq[k] rotatedaround(((N-1)/2,(N-1)/2), 90);
            fi;
        endfor;

        for k=0 upto N-1:
            drawit(qq[k] scaled u);
        endfor;

        for i=0 upto N-1:
            for j=0 upto N-1:
                draw (i,j) scaled u withpen pencircle scaled 8pt withcolor white;
                draw (i,j) scaled u withpen pencircle scaled 6pt;
            endfor;
        endfor;

        path cc;
        cc := unitsquare xscaled 14u yscaled 14u;
        cc := cc shifted ((3u,3u) - center cc);
        draw cc withcolor red;

        picture p;
        p := currentpicture;
        currentpicture := nullpicture;

        p
    enddef;

    numeric shift;
    shift := 10u;

    picture pic[];

    pic[0] := drawpic((1,0));
    pic[1] := drawpic((0,1));
    pic[2] := drawpic((1,1));
    pic[3] := drawpic((-1,1));
    pic[4] := drawpic((2,1));
    pic[5] := drawpic((-2,1));
    pic[6] := drawpic((1,2));
    pic[7] := drawpic((-1,2));

    for i=1 upto 3:
        pic[i] := pic[i] shifted (xpart urcorner pic[i-1] - xpart ulcorner pic[i],0);
    endfor;
    pic[4] := pic[4] shifted (0,(ypart llcorner pic[4] - ypart ulcorner pic[4]));
    for i=5 upto 7:
        pic[i] := pic[i] shifted (xpart urcorner pic[i-1] - xpart ulcorner pic[i],(ypart llcorner pic[i] - ypart ulcorner pic[i]));
    endfor;

    for i=0 upto 7:
        draw pic[i];
    endfor;

    pic[6] := currentpicture;

    fill bbox currentpicture withcolor black;
    draw pic[6];

endfig;
end;