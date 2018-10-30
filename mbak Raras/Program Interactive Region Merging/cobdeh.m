load fisheriris
Z = linkage(meas,'average','chebychev');
c = cluster(Z,'maxclust',3);
cutoff = median([Z(end-2,3) Z(end-1,3)]);
dendrogram(Z,'ColorThreshold',cutoff);