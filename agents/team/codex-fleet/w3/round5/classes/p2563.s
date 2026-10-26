# n=5 model=out iset=I1 prefix14_class=2563
mov S0, P0
cmp P2, P0
mov S1, P1
cmovl P0, P2
cmovg S0, P2
cmp P3, S1
cmovg P1, P3
cmovg P3, S1
cmp S0, P1
mov S1, S0
cmovle S1, P1
cmovg S0, P1
mov S2, S0
cmp P3, P0
