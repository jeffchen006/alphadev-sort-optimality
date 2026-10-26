# n=5 model=out iset=I1 prefix14_class=1194
cmp P1, P0
mov S2, P2
cmovle S1, P1
cmovl P1, P0
cmovle P0, S1
cmp P2, P3
mov S1, P1
cmovl S2, P3
cmovge P2, P3
cmp S1, S2
cmovg S1, S2
cmovge S2, P1
cmp P2, P0
cmovle S0, P2
