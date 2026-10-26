# n=5 model=out iset=I1 prefix14_class=8020
mov S2, P3
cmp S2, P0
mov S0, P1
cmovle P3, P0
cmovge S2, P0
cmp P1, P2
cmovge P1, P2
cmovl S0, P2
mov S1, P1
cmp P1, S2
cmovle S1, S2
cmovle S2, P1
cmp P3, S0
cmovle P1, P3
