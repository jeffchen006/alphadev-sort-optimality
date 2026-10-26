# n=5 model=out iset=I1 prefix14_class=3567
cmp P2, P1
cmovle S1, P2
cmovle P2, P1
cmovl P1, S1
cmp P3, P0
mov S0, P0
cmovg P0, P3
cmovl S0, P3
cmp P1, S0
cmovg S2, P1
cmovge P1, S0
cmovg S0, S2
mov S2, P0
cmp P2, P0
