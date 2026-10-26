# n=5 model=out iset=I1 prefix14_class=9935
cmp P1, P0
mov S0, P0
cmovg S0, P1
cmovle P0, P1
cmp P3, P2
cmovg P1, P3
mov S1, S0
cmovg P3, P2
mov S2, P0
cmovg P2, P1
cmp S1, P2
cmovl S0, P2
cmovge S1, P2
cmp S2, P3
