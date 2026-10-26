# n=5 model=out iset=I1 prefix14_class=2493
mov S2, P0
mov S0, P1
cmp P2, P0
cmovl S2, P2
cmovl P2, P0
cmp P3, S0
mov S1, P2
cmovg P1, P3
cmovg P3, S0
cmp P2, P1
cmovle S1, P1
mov S1, S2
cmovl P1, P2
mov P0, P1
