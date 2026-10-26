# n=5 model=out iset=I1 prefix14_class=1256
mov S2, P3
cmp P0, P3
cmovge S2, P0
cmovg P0, P3
cmp P2, P1
mov S0, S2
cmovg P3, P2
cmovle P3, P1
cmovl P1, P2
cmp S2, P3
mov S1, P1
cmovl S0, P3
cmovg S2, P3
cmp S1, P0
