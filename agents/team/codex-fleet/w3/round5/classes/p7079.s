# n=5 model=out iset=I1 prefix14_class=7079
mov S1, P3
cmp P1, S1
cmovge S1, P1
cmovge P1, P3
mov S0, P1
cmp P0, P2
cmovge P3, P0
cmovge P0, P2
cmovge P2, P3
cmp P0, P1
cmovge P1, P0
mov S2, P2
cmovle S0, P0
cmovl P0, P1
