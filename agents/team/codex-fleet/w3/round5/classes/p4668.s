# n=5 model=out iset=I1 prefix14_class=4668
mov S0, P3
cmp P1, P3
mov S1, P2
cmovg P3, P1
cmovge P1, S0
cmp P0, S1
cmovle P2, P0
mov S2, P2
cmovl P0, S1
cmp P0, P3
cmovg S0, P3
cmovge P3, P0
cmovg P0, S0
cmp P2, P1
