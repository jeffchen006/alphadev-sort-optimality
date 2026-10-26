# n=5 model=out iset=I1 prefix14_class=2100
mov S1, P0
cmp P1, S1
cmovl S1, P1
cmovg P0, P1
cmp P3, P2
mov S2, P3
cmovge P3, P2
cmovle S2, P2
mov S0, S2
cmp P0, S0
cmovge S2, P0
mov S2, P3
cmovge P0, S0
mov P2, P0
