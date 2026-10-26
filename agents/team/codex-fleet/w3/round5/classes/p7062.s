# n=5 model=out iset=I1 prefix14_class=7062
mov S1, P2
cmp P3, S1
cmovg P2, P3
cmovge P3, S1
cmp P0, P1
cmovg S1, P0
cmovg P0, P1
cmovg P1, S1
mov S0, P2
cmp P3, P0
mov S2, P3
cmovle P3, P0
cmovl P0, S2
cmp P2, P1
