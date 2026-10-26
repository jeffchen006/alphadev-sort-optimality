# n=5 model=out iset=I1 prefix14_class=6287
cmp P0, P2
mov S0, P2
cmovl S0, P0
cmovge P2, P0
cmp P1, P3
cmovge S1, P3
cmovg P3, P1
cmovge P1, S1
mov S2, P3
cmp S2, P2
cmovle S2, P2
cmovle P2, P3
mov P3, S0
cmp P3, P1
