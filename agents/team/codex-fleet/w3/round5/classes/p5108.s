# n=5 model=out iset=I1 prefix14_class=5108
cmp P0, P3
cmovle S0, P3
mov S2, P1
cmovg S0, P0
cmovg P0, P3
cmp S2, P2
cmovl S2, P2
cmovg P1, P2
mov P2, P0
cmp P1, P0
cmovg P2, P1
mov S1, S0
cmovl P0, P1
mov P0, P2
