# n=5 model=out iset=I1 prefix14_class=2365
mov S1, P0
mov S0, P2
cmp P0, P3
cmovle S1, P3
cmovg P0, P3
cmp P1, S0
cmovg S0, P1
cmovl P2, P1
cmovl P1, S0
cmp S1, S0
cmovl P1, S1
cmovg S0, S1
cmp P2, P0
cmovge S0, P2
