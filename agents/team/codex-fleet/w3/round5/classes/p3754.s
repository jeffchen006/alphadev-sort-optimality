# n=5 model=out iset=I1 prefix14_class=3754
cmp P3, P2
cmovle S1, P3
mov S2, P0
cmovge S1, P2
mov S0, S1
cmovg P2, P3
cmp P1, P0
cmovge P0, P1
cmovge P1, S2
cmp P1, S0
cmovge S0, P1
cmovl S1, P1
mov P1, P2
cmp P1, P0
