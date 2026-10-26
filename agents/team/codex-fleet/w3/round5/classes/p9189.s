# n=5 model=out iset=I1 prefix14_class=9189
mov S2, P3
cmp P1, S2
cmovl S2, P1
cmovg P3, P1
cmp P2, P0
cmovle P1, P2
cmovg P1, P0
cmovl P2, P0
cmp S2, P1
cmovge S0, S2
cmovg S2, P1
mov S2, P2
cmovg P1, S0
cmp P3, P2
