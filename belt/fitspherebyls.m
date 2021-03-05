function [a,b,c,R] = fitspherebyls(xyz)
%% use Least-Squares to fit sphere
% xyz
% x1 y1 z1
% x2 y2 z2
% x3 y3 z3
% x4 y4 z4

    % È¥³ýÖØ¸´µã
    data = unique(xyz,'rows');
    row = size(data,1);
    if row<4
        warning('points too less');
        a = [];
        b = [];
        c = [];
        R = [];
        return;
    end
    syms x y z a b c R;
    F = sym(((x-a)^2+ (y-b)^2+ (z-c)^2-R^2)^2);
    Fda = diff(F,'a');
    Fdb = diff(F,'b');
    Fdc = diff(F,'c');
    FdR = diff(F,'R');

    Q1 = sym(0);
    Q2 = sym(0);
    Q3 = sym(0);
    Q4 = sym(0);

    for i = 1:row
        Q1 = Q1+subs(Fda,{x,y,z},{data(i,:)});
        Q2 = Q2+subs(Fdb,{x,y,z},{data(i,:)});
        Q3 = Q3+subs(Fdc,{x,y,z},{data(i,:)});
        Q4 = Q4+subs(FdR,{x,y,z},{data(i,:)});
    end
% maybe accelerate the next step's solving
%     Q1 = simplify(Q1);
%     Q2 = simplify(Q2);
%     Q3 = simplify(Q3);
%     Q4 = simplify(Q4);

    [a,b,c,R] = solve([Q1,Q2,Q3,Q4],[a,b,c,R]);

    % get valid resolver index
    exactindex = find(R>0);
    if length(exactindex)~=1
        warning('there exists several solvers!');
    end
    a = a(exactindex);
    b = b(exactindex);
    c = c(exactindex);
    R = R(exactindex);

    a = double(a);
    b = double(b);
    c = double(c);
    R = double(R);
end