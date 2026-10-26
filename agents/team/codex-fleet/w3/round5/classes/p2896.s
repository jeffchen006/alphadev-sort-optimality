# n=5 model=out iset=I1 prefix14_class=2896
mov S1, P2
cmp S1, P0
cmovl P2, P0
cmovle P0, S1
mov S0, P2
mov S1, P3
cmp P3, P1
cmovl S1, P1
cmovg P3, P1
cmp P2, S1
cmovle S0, S1
cmovg P2, S1
cmp P0, P3
cmovg S2, P0
