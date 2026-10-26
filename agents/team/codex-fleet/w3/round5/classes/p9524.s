# n=5 model=out iset=I1 prefix14_class=9524
mov S0, P2
cmp P1, P0
mov S2, P1
cmovl S2, P0
cmovle P0, P1
mov S1, P0
cmp P2, P3
cmovl S0, P3
cmovg P2, P3
cmp P2, P0
cmovl P0, P2
cmovg S1, P2
cmp S2, S0
cmovge P2, S0
