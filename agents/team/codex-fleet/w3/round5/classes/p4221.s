# n=5 model=out iset=I1 prefix14_class=4221
mov S1, P3
cmp P1, P3
cmovge S1, P1
cmovle P3, P1
mov S0, P2
cmp P0, P2
cmovl S0, P0
cmovge P2, P0
mov S2, S0
cmp P3, S2
cmovg S2, P3
cmovle S0, P3
mov P3, P2
cmp S1, P3
