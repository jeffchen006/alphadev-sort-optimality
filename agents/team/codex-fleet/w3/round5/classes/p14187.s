# n=5 model=out iset=I1 prefix14_class=14187
cmp P3, P0
mov S1, P2
cmovle S0, P0
cmovg S0, P3
cmovl P0, P3
cmp S1, P1
cmovl P2, P1
cmovg S1, P1
cmp P2, S0
cmovg P3, S0
cmovg S0, P2
mov S0, S1
cmovg P2, P3
cmp P0, S0
