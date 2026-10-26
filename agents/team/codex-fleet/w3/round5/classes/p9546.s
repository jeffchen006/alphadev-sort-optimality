# n=5 model=out iset=I1 prefix14_class=9546
cmp P1, P0
cmovge S0, P0
cmovg P0, P1
mov S2, P2
cmovg P1, S0
cmp S2, P3
cmovl S2, P3
cmovg P2, P3
cmp P2, P1
mov S1, P2
cmovle P2, P1
mov P3, P2
cmovg S1, P1
mov S1, P0
