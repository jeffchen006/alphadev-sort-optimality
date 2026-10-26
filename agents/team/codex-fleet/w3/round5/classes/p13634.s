# n=5 model=out iset=I1 prefix14_class=13634
cmp P2, P1
cmovle S2, P1
cmovl P1, P2
mov S0, P3
cmovg S2, P2
cmp P3, P0
cmovg P3, P0
cmovl S0, P0
cmp P1, P3
cmovg S1, P3
cmovg P3, P1
cmovg P1, S1
cmp S2, S0
mov P1, S0
