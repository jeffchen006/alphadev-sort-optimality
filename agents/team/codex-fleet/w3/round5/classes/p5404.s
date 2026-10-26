# n=5 model=out iset=I1 prefix14_class=5404
mov S2, P2
cmp P0, S2
cmovg S2, P0
cmovg P0, P2
mov S0, P1
cmp P1, P3
cmovl S0, P3
cmovle P3, P1
cmp P3, P0
cmovg P1, P3
cmovge P3, P0
cmovg P0, P1
cmp S0, S2
cmovl P1, S2
