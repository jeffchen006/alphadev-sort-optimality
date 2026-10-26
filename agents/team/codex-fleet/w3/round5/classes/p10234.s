# n=5 model=out iset=I1 prefix14_class=10234
cmp P1, P3
mov S1, P3
cmovl P3, P1
mov S0, P3
cmovg S1, P1
cmp P2, P0
cmovge S2, P0
cmovge P0, P2
cmovge P2, S2
mov P1, S1
cmp P0, S1
cmovle P1, P0
cmovg S1, P0
cmp P3, P2
