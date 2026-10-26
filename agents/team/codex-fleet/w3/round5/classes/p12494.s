# n=5 model=out iset=I1 prefix14_class=12494
cmp P0, P1
mov S1, P2
cmovg S2, P1
cmovg P1, P0
cmovg P0, S2
cmp P3, P2
cmovle S1, P3
cmovl P3, P2
mov S0, S1
cmp S0, P0
cmovg S1, P0
cmovl S0, P0
cmp P3, P1
cmovg S1, P1
