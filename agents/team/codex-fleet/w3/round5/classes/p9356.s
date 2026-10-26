# n=5 model=out iset=I1 prefix14_class=9356
cmp P0, P3
mov S2, P3
cmovl S2, P0
cmovle P0, P3
mov S1, P2
cmp P1, P2
cmovl S1, P1
cmovle P1, P2
cmp S1, S2
cmovg P3, S2
cmovg S2, S1
cmovg S1, P3
cmp P1, P0
cmovl S0, P0
