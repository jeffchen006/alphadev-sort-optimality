# n=5 model=out iset=I1 prefix14_class=13517
cmp P2, P3
cmovg S0, P2
mov S1, P1
cmovge P2, P3
cmovg P3, S0
cmp P1, P0
mov S2, P2
cmovge S1, P0
cmovle P1, P0
cmp P2, S1
cmovle P2, S1
cmovge S2, S1
mov S2, P3
cmp P3, P1
