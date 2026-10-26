# n=5 model=out iset=I1 prefix14_class=4750
cmp P0, P3
mov S0, P0
cmovle S0, P3
cmovge P0, P3
cmp P2, P1
mov S1, P0
cmovl P3, P1
cmovge P3, P2
cmovge P2, P1
cmp P2, S1
cmovge S1, P2
cmovge P2, P0
mov P2, P3
mov S2, S1
