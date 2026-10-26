# n=5 model=out iset=I1 prefix14_class=3854
mov S0, P3
cmp P3, P2
cmovge P3, P2
cmovge P2, S0
cmp P0, P1
cmovg S1, P0
cmovle S1, P1
cmovl P1, P0
mov S2, P3
cmp P3, P1
cmovl P3, P1
cmovl P1, S2
cmp S1, P2
cmovge P1, P2
