# n=5 model=out iset=I1 prefix14_class=9143
mov S0, P3
cmp P0, S0
cmovle S0, P0
cmovg P3, P0
cmp P2, P1
cmovl P0, P1
mov S2, S0
cmovl P1, P2
cmovl P2, P0
cmp S0, P1
cmovg S2, P1
cmovle S0, P1
cmovg P1, S0
mov S1, P3
