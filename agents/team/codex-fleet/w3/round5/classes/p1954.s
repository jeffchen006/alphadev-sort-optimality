# n=5 model=out iset=I1 prefix14_class=1954
cmp P2, P1
cmovl S0, P2
mov S1, P3
cmovge S0, P1
cmovle P2, P1
cmp P0, P3
cmovge P3, P0
cmovle S1, P0
mov S2, P2
cmp P3, S2
cmovle S2, P3
cmovge P2, P3
mov P1, S2
cmp S1, S0
