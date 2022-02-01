% input: seq - sequence of all ORs; TM - transmembrance information of each OR
% output: TM_seq - ORs with Tm sequence if T.start and TM. stop is not zero, 
%           otherwise return the whole sequence

function TM_seq = get_7TM_seq(seq, TM)

TM_seq = seq;
for i = 1:size(TM,1)
    TM_OR = TM.OR(i);
    if (TM.start(i) ~= 0) && (TM.stop(i) ~= 0)
        OR = seq(strcmp({seq.Header}, TM_OR) == 1).Sequence(TM.start(i):TM.stop(i));
        TM_seq(strcmp({seq.Header}, TM_OR) == 1).Sequence = OR;
    else
        TM_seq(strcmp({seq.Header}, TM_OR) == 1).Sequence = '';
    end
end
end

