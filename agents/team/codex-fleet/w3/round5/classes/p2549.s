# n=5 model=out iset=I1 prefix14_class=2549
mov S2, P2
mov S1, P1
cmp P2, P0
cmovle S2, P0
cmovl P0, P2
cmovl P2, S2
cmp P1, P3
cmovl S1, P3
cmovl P3, P1
cmp S2, S1
cmovl P2, S1
cmovle S1, S2
mov P2, P3
mov S0, S1
