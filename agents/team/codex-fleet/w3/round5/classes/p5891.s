# n=5 model=out iset=I1 prefix14_class=5891
mov S1, P0
mov S2, P1
cmp P3, P0
cmovge P0, P3
cmovge P3, S1
cmp P2, S2
cmovle S2, P2
cmovl P2, P1
cmp P2, P0
cmovge S0, P0
cmovge P0, P2
cmovle S0, P2
cmp P3, S2
cmovl P0, P3
