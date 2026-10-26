# n=5 model=out iset=I1 prefix14_class=3788
cmp P1, P3
cmovg S2, P1
cmovge P1, P3
cmovg P3, S2
cmp P2, P0
mov S0, P2
mov S1, P1
cmovle P2, P0
cmovg S0, P0
cmp P1, S0
cmovl P1, S0
cmovl S0, S1
mov S0, P2
cmp P3, P2
