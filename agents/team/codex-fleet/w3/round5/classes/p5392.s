# n=5 model=out iset=I1 prefix14_class=5392
mov S2, P1
cmp P2, P3
mov S0, P3
cmovle S0, P2
cmovl P2, P3
cmp P1, P0
cmovl P1, P0
cmovg S2, P0
mov S1, S2
cmp S0, S1
cmovle S1, S0
cmovg S2, S0
cmp P2, P1
mov S1, P1
