# n=5 model=out iset=I1 prefix14_class=2897
mov S0, P2
cmp S0, P0
cmovl P2, P0
cmovl P0, S0
mov S1, P2
mov S0, P3
cmp P3, P1
cmovl S0, P1
cmovg P3, P1
cmp P2, S0
cmovle S1, S0
cmovg P2, S0
cmp P3, P0
cmovg S2, P3
