# n=5 model=out iset=I1 prefix14_class=7916
cmp P1, P3
mov S2, P1
cmovle P1, P3
cmovle P3, S2
mov S1, P0
cmp P2, S1
cmovge P0, P2
cmovle S1, P2
cmp P3, S1
cmovge S2, S1
cmovl S2, P3
cmovg S1, P3
cmp P0, P1
cmovle P2, P0
