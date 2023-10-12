beginfig(1);

    tracingonline := 1;
    numeric u, N;
    N := 5;
    u := 1cm;

    def randomcolor = (uniformdeviate(1), uniformdeviate(1), uniformdeviate(1)) enddef;

    vardef sort_by_min(expr l)(suffix p) = 
        path swp;
        for i=0 upto l-1: 
            for j=i+1 upto l:
                show(j);
                if (ypart point 0 of p[i]) < (ypart point 0 of p[j]):
                    swp := p[i];
                    p[i] := p[j];
                    p[j] := swp;
                fi;
            endfor;
        endfor;
        p
    enddef;

    vardef build_line(expr d, b) = 
        numeric ii;
        ii := 0;
        path pp[];
        pair r, q;
        pp[ii] := (0,b);
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

        pair dd, ee;
        dd := 5*unitvector d;
        ee := dd rotated 180;
        path qq;
        qq := pp[0] for i=1 upto ii-1:  
                if odd i: 
                    .. controls ((point length(pp[i-1]) of pp[i-1]) + dd) 
                    and ((point 0 of reverse(pp[i])) + dd) .. reverse(pp[i])
                else: 
                    .. controls ((point length(reverse(pp[i-1])) of reverse(pp[i-1])) - dd) 
                    and ((point 0 of pp[i]) - dd) .. pp[i] 
                fi
            endfor;
        qq
    enddef;

    def drawit(expr p) = 
        draw p withpen pencircle scaled 4pt withcolor white;
        draw p withpen pencircle scaled 2pt withcolor randomcolor;
    enddef;

    vardef drawpic(expr n) =

        path qq;

        for i=0 upto 4:
            drawit (((i,0)--(i,N-1)) scaled u);
        endfor;

        for i=0 upto N-1:
            drawit (((0,i)--(N-1,i)) scaled u);
        endfor;
        
        for k=0 upto N-1:
            qq := build_line((abs(n),1), k);
            if n<0:
                qq := qq xscaled -1 shifted(4,0);
            fi;
            drawit (qq scaled u);
        endfor;
    
        for i=0 upto N-1:
            for j=0 upto N-1:
                draw (i,j) scaled u withpen pencircle scaled 8pt withcolor white;
                draw (i,j) scaled u withpen pencircle scaled 6pt;
            endfor;
        endfor;

        picture p;
        p := currentpicture;
        currentpicture := nullpicture;

        p
    enddef;

    numeric shift;
    shift := 10u;

    picture pic[];
    pic[0] := drawpic(1);
    pic[1] := drawpic(2);
    pic[2] := drawpic(-2);
    pic[3] := drawpic(-1);

    for i=1 upto 3:
        pic[i] := pic[i] shifted (xpart urcorner pic[i-1] - xpart ulcorner pic[i],0);
    endfor;

    for i=0 upto 3:
        draw pic[i];
    endfor;



    pic[4] := currentpicture;

    fill bbox currentpicture withcolor black;
    draw pic[4];

endfig;
end;