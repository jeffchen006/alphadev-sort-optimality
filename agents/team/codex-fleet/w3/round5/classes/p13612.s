# n=5 model=out iset=I1 prefix14_class=13612
cmp P0, P1
mov S1, P1
mov S2, P3
cmovg S1, P0
cmovl P1, P0
cmp P2, S2
cmovl S2, P2
cmovg P3, P2
cmp S2, P1
cmovle S0, P1
cmovl P1, S2
cmovl S2, S0
mov P2, S1
cmp S1, P3
