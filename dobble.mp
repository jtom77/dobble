tracingonline := 1;
    
N := 7;
u := 1cm;
pair MID;
MID := ((N-1)/2,(N-1)/2);

def randomcolor = (uniformdeviate(1), uniformdeviate(1), uniformdeviate(1)) enddef;

vardef get_line(expr d, offs) = 

    % linear path segments, might be a degenerated path with only one point 
    path seg[];

    len := 0;
    seg[len] := (0, offs);
    
    for i=0 upto N-1:
        pair q,qmod;
        q := point length(seg[len]) of seg[len] + d;
        qmod := (xpart q mod N, ypart q mod N);
        if q=qmod:
            seg[len] := seg[len]--qmod;
        else:
            len := len+1;
            seg[len] := qmod;
        fi;
    endfor;

    % Sort the segments descending bei their y coordinate 
    seg := sort_desc(len-1)(seg);

    % Every second segment should reverse it direction before merged
    for i=0 upto len:
        if odd i: seg[i] := reverse(seg[i]); fi
    endfor;

    path p; p := seg[0];
    for i=1 upto len-1:
        p := merge_lines(p, seg[i]);
    endfor;

    p
enddef;

vardef merge_lines(expr p, q) =
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
    
    p .. controls (a+d) and (b+d) .. q
enddef;

vardef sort_desc(expr l)(suffix p) = 
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

def draw_line(expr p) = 
    draw p withpen pencircle scaled 4pt withcolor white;
    draw p withpen pencircle scaled 2pt withcolor randomcolor;
enddef;

vardef draw_tile(expr w, p_inf) =

    path qq[];
    boolean rotate;
    rotate := false;

    % The vector v is used to actually draw the lines. 
    % Afterwards, the whole picture is transformed to match the input w. 
    transform t;
    t := identity;
    pair v; 
    v := (abs(xpart w), abs(ypart w));
    if xpart w<0:
        t := t xscaled -1 shifted(N-1,0);
    fi;
    if xpart v < ypart v:
        v := (ypart v, xpart v);
        t := t rotatedaround(MID, 90);
    fi;

    for k=0 upto N-1:
        qq[k] := get_line(v, k);
    endfor;

    numeric min, max;
    min := 1000; max := 0;
    for k=0 upto N-1:
        if ypart(point 0 of qq[k]) < min:
            min := ypart point 0 of qq[k];
        fi;
        if ypart(point 0 of qq[k]) > max:
            max := ypart point 0 of qq[k];
        fi;
    endfor;
    
    pair inf;         
    inf := .5[(0,min),(0,max)] shifted (-3*unitvector(v));

    for k=0 upto N-1:
        if (p_inf): 
            qq[k] := inf .. qq[k];
        fi;
        qq[k] := qq[k] transformed t;
    endfor;

    for k=0 upto N-1:
        draw_line(qq[k] scaled u);
    endfor;

    if (p_inf):
        inf := inf transformed t;
        draw inf scaled u withpen pencircle scaled 8pt withcolor white;
    fi;

    for i=0 upto N-1:
        for j=0 upto N-1:
            draw (i,j) scaled u withpen pencircle scaled 8pt withcolor white;
            draw (i,j) scaled u withpen pencircle scaled 6pt;
        endfor;
    endfor;

    path cc;
    cc := unitsquare xscaled 14u yscaled 14u;
    cc := cc shifted (MID scaled u - center cc);
    draw cc withcolor white;

    picture p; 
    p := currentpicture;
    currentpicture := nullpicture;
    
    p
enddef;

vardef draw_pic(expr p_inf) = 

    picture pic[];

    i := 0;
    for w=(0,1),(1,0),(1,1),(-1,1),(2,1),(-2,1),(1,2),(-1,2):
        pic[i] := draw_tile(w, p_inf);
        i := i+1;
    endfor;

    shift := (xpart urcorner pic[0]) - (xpart ulcorner pic[0]);
    for i=0 upto N:
        pic[i] := pic[i] shifted ((i mod 4) * shift, - (floor(i/4) * shift));
        draw pic[i];
    endfor;

    pic[6] := currentpicture;

    fill bbox currentpicture withcolor black;
    draw pic[6];
enddef;


beginfig(1);
    draw_pic(false);
endfig;

beginfig(2);
    draw_pic(true);
endfig;

end;