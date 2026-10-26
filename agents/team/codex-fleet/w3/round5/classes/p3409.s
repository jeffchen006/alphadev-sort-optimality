# n=5 model=out iset=I1 prefix14_class=3409
cmp P2, P3
mov S1, P3
cmovl S1, P2
cmovge P3, P2
mov S0, P0
cmp P0, P1
cmovl S0, P1
cmovle P1, P0
mov P0, P1
cmp S1, P0
cmovge P0, S1
cmovle P1, S1
cmp P3, S0
cmovle S2, P3
