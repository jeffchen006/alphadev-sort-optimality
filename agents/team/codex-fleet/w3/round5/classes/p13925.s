# n=5 model=out iset=I1 prefix14_class=13925
cmp P3, P0
cmovle S1, P3
cmovle P3, P0
cmovl P0, S1
cmp P1, P2
cmovge S2, P1
cmovle S2, P2
cmovge P1, P2
mov P2, S2
cmp P3, P2
cmovge S2, P3
cmovge P3, P2
cmp P1, P0
cmovle P2, P0
