# n=5 model=out iset=I1 prefix14_class=51
mov S2, P2
cmp P1, S2
cmovle S2, P1
mov S1, P0
mov S0, S2
cmovle P1, P2
cmp P3, P0
mov P2, P1
cmovge P0, P3
cmovle S1, P3
cmp S0, S1
cmovl S2, S1
cmovge S0, S1
cmp P2, P0
