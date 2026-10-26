# n=5 model=out iset=I1 prefix14_class=174
mov S1, P2
cmp P2, P1
cmovg S1, P1
cmovl P2, P1
mov S0, P0
cmp P3, P0
cmovle S0, P3
cmovl P3, P0
cmovl P0, S0
cmp S1, S0
cmovg P0, S1
cmovg S1, S0
cmp P2, P3
cmovg S0, P2
