# n=5 model=out iset=I1 prefix14_class=5100
mov S0, P0
cmp P0, P2
cmovg P0, P2
cmovle S0, P2
cmp P1, P3
mov S1, P0
cmovle S2, P3
cmovg S2, P1
cmovg P1, P3
cmp S1, P1
cmovl P0, P1
cmovl P1, S1
cmp S0, S2
cmovl P3, S0
