# n=5 model=out iset=I1 prefix14_class=8090
mov S0, P2
cmp P2, P0
cmovle S0, P0
cmovge P2, P0
cmp P3, P1
mov S2, P2
cmovge P0, P1
mov S1, S0
cmovg P1, P3
cmovg P3, P0
cmp P3, S2
cmovl S2, P3
cmovge P2, P3
cmp P1, S1
