# n=5 model=out iset=I1 prefix14_class=9790
cmp P3, P2
cmovge S0, P2
cmovge P2, P3
mov S2, P0
cmovge P3, S0
cmp P0, P1
cmovge S2, P1
mov S1, P2
cmovl P0, P1
cmp P0, S1
cmovge P2, P0
cmovge P0, S1
mov P2, P3
cmovle S1, P0
