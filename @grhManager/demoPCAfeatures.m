function demoPCAfeatures(obj, prc)

% demonstrate PCA dimension features


[A, B, evalues] = obj.PCAonFDs;

if nargin == 1
    prc = 5;
end

A05 = prctile(A, prc);
A95 = prctile(A, 100-prc);

for j = 1:3

    figure;
    
    Aind05=A(:,j) < A05(j);
    Aind95=A(:,j) > A95(j);

    [rws,cls] = grhOptSubPlots(sum(Aind05)+sum(Aind95));

    n = 1;
    for i = find(Aind05)'
        subplot(rws,cls,n);
        n=n+1;
        obj.cells(B(i,1)).snake(B(i,2)).plot;
        axis equal
        axis off
    end

    n=n+1;

    for i = find(Aind95)'
        subplot(rws,cls,n);
        n=n+1;
        obj.cells(B(i,1)).snake(B(i,2)).plot('r');
        axis equal
        axis off
    end
    
    suptitle({['Bottom ' num2str(prc) '% (blue) and top ' num2str(prc) ...
        '% (red) shapes in PCA dimension ' num2str(j)];  ...
        ['which has normalised power ' num2str(evalues(j)/evalues(1))]})
end