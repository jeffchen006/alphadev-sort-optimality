# n=5 model=out iset=I1 prefix14_class=96
mov S1, P0
cmp P2, P0
mov S2, P3
cmovge S1, P2
cmovg P2, P0
cmp P1, S2
cmovge P3, P1
mov P0, P3
cmovl S2, P1
cmp P2, S2
mov S0, S2
cmovle S2, P2
cmovge S0, P2
cmp P0, S1
