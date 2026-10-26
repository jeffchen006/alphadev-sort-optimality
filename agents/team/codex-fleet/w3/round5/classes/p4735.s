# n=5 model=out iset=I1 prefix14_class=4735
cmp P3, P2
cmovge S0, P2
cmovle S0, P3
cmovl P3, P2
cmp P1, P0
mov P2, P0
cmovge P0, P1
mov S1, S0
cmovge P1, P2
cmp P1, S1
cmovge S1, P1
cmovge P1, S0
cmp P3, P0
cmovle S0, S1
