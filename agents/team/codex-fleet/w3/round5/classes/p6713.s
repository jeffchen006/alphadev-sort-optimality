# n=5 model=out iset=I1 prefix14_class=6713
cmp P0, P3
cmovge S0, P0
cmovg P0, P3
cmovl S0, P3
cmp P1, P2
mov S2, P2
cmovle P2, P1
cmovge S2, P1
cmp S2, S0
mov P1, S0
cmovge P1, S2
cmovle S0, S2
cmp P2, P0
cmovl S2, P2
