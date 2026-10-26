# n=5 model=out iset=I1 prefix14_class=4566
mov S1, P0
cmp P1, S1
cmovl S1, P1
cmovg P0, P1
cmp P3, P2
cmovge S0, P3
cmovle S0, P2
cmovge P3, P2
cmp P0, S0
cmovle S2, P0
cmovge S2, S0
cmovge S0, P0
mov P2, S2
cmp P3, S1
