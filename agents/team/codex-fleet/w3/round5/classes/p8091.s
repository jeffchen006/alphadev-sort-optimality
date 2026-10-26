# n=5 model=out iset=I1 prefix14_class=8091
mov S0, P2
cmp P2, P3
cmovle S0, P3
cmovge P2, P3
cmp P0, P1
mov S2, S0
cmovge P3, P1
mov S1, P2
cmovge P1, P0
cmovg P0, P3
cmp P0, S1
cmovge P2, P0
cmovl S1, P0
cmp P1, S2
