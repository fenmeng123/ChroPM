function tGV=CCC_tGV(DFC_var,Num_nodes,Num_edges,FCx,FCy,isub)

adja_DFCvar=zeros(Num_nodes,Num_nodes);
for ifc=1:Num_edges
    adja_DFCvar(FCx(ifc),FCy(ifc))=DFC_var(isub,ifc);
end
adja_DFCvar=adja_DFCvar+adja_DFCvar';
tGV(1,:)=sum(adja_DFCvar);