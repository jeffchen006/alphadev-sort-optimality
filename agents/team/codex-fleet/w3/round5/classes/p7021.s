# n=5 model=out iset=I1 prefix14_class=7021
cmp P1, P0
cmovge S2, P1
cmovle S2, P0
cmovg P1, P0
mov S0, P3
cmp S0, P2
cmovl S0, P2
cmovg P3, P2
mov S1, P1
cmp P1, P3
cmovg P1, P3
cmovg P3, S1
mov P1, P3
mov S1, S0
