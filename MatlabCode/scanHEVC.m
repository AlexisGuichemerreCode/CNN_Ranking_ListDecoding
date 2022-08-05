function sliceTab = scanHEVC(fid)

    sliceTab = [];
    go = 1;
    cpt = 0;
    cptZero = 0;
    numSlice = 0;
    cpt=0;
    
    
    while(go)
        b = fread(fid,1,'ubit1','ieee-be');
        if ~isempty(b)
            cpt = cpt+1;
            if b==0
                cptZero = cptZero+1;
            else
                if numSlice==0 && cptZero>=31
                    numSlice = numSlice + 1;
                else
                    if numSlice<3 && cptZero>=31
                        sliceTab = [sliceTab (cpt/8)-4];
                        cpt = 32;
                        numSlice = numSlice + 1;
                    else 
                        if numSlice>=3 && cptZero>=23
                            if cptZero>=31
                                sliceTab = [sliceTab (cpt/8)-4];
                                cpt = 32;
                            else
                                sliceTab = [sliceTab (cpt/8)-3];
                                cpt = 24;
                            end
                            numSlice = numSlice + 1;
                        end
                    end
                end
                cptZero = 0;
            end
        else
            sliceTab = [sliceTab (cpt/8)];
            go = 0;
        end 
    end
end