function [TM]=ThresholdMussel(outline,inline,IM,se)
%Make thresholded image of mussel boundaries
TMout=false(size(IM));
TMin=false(size(IM));
for i = 1:length(outline)
    TMout(outline(1,i),outline(2,i))=1;
    TMin(inline(1,i),inline(2,i))=1;
end
TMout_c=imclose(TMout,se);
TMin_c=imclose(TMin,se);
TM=logical(imadd(TMout_c,TMin_c));
end