# n=5 model=out iset=I1 prefix14_class=4926
mov S0, P2
cmp P2, P3
cmovle S0, P3
mov S2, P1
cmovg P2, P3
cmp S2, P0
cmovl P1, P0
mov S1, P1
cmovle P0, S2
cmp P2, P0
cmovge S2, P2
cmovge P2, P0
cmovge P0, S2
cmp S1, S0
