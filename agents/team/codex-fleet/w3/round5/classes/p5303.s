# n=5 model=out iset=I1 prefix14_class=5303
cmp P2, P1
cmovge S1, P2
cmovge P2, P1
cmovge P1, S1
mov S2, P0
cmp S2, P3
cmovg P0, P3
mov S0, P0
cmovle S2, P3
cmp S0, P2
cmovl S0, P2
cmovle P2, P0
cmp S2, P1
mov P2, S2
