# n=5 model=out iset=I1 prefix14_class=3026
mov S1, P0
cmp S1, P1
cmovle S1, P1
cmovle P1, P0
mov S2, P2
cmp P2, P3
cmovge P2, P3
cmovl S2, P3
cmovge P3, S2
cmp S1, P3
cmovg S2, S1
cmovle P3, S1
cmp P1, P2
cmovge S0, P2
