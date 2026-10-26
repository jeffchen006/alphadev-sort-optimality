# n=5 model=out iset=I1 prefix14_class=9140
cmp P1, P3
cmovge S1, P1
cmovg P1, P3
mov S0, P0
cmovl S1, P3
cmp P0, P2
cmovl S0, P2
mov S2, P1
cmovg P0, P2
cmp S2, P0
cmovge P1, P0
cmovle S2, P0
mov P1, S2
cmp S1, S0
