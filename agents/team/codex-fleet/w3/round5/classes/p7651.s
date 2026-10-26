# n=5 model=out iset=I1 prefix14_class=7651
mov S2, P3
cmp P1, S2
cmovl P3, P1
mov S0, P2
cmovg S2, P1
cmp P0, P2
cmovg P2, P0
cmovle S0, P0
cmp P3, S0
cmovle S1, P3
mov P1, S2
cmovl P3, S0
cmovle S0, S1
cmp P2, S2
