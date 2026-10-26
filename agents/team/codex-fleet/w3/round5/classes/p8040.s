# n=5 model=out iset=I1 prefix14_class=8040
cmp P2, P1
mov S1, P0
cmovge S0, P2
cmovge P2, P1
cmovge P1, S0
cmp P3, S1
cmovge P0, P3
cmovge P3, S1
mov S2, P3
cmp P3, P2
cmovg S2, P2
cmovle P3, P2
cmp P1, P0
cmovl S0, P1
