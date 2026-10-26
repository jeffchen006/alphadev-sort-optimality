# n=5 model=out iset=I1 prefix14_class=10163
cmp P0, P2
mov S0, P3
cmovg S2, P0
cmovg P0, P2
cmovg P2, S2
cmp P1, P3
cmovle S0, P1
cmovl P1, P3
mov S1, P1
cmp P2, S1
cmovl S1, P2
cmovg P1, P2
cmp P0, S0
mov P1, S1
