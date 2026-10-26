# n=5 model=out iset=I1 prefix14_class=3564
cmp P0, P2
cmovle S1, P0
cmovle P0, P2
mov S2, P1
cmovle P2, S1
mov S0, P0
cmp P3, S2
cmovl P1, P3
cmovg S2, P3
cmp P1, P2
cmovg S1, P1
cmovge P1, P2
cmovg P2, S1
cmp S2, P0
