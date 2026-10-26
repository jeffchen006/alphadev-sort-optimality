# n=5 model=out iset=I1 prefix14_class=3674
mov S1, P3
cmp P0, P3
cmovl P3, P0
cmovg S1, P0
mov S0, P3
cmp P1, P2
cmovle S2, P1
cmovl P1, P2
cmovl P2, S2
cmp S0, P2
cmovl S0, P2
cmovl P2, P3
mov P3, P1
cmp S1, P3
