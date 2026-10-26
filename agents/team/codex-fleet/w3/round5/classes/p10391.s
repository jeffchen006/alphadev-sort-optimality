# n=5 model=out iset=I1 prefix14_class=10391
mov S2, P3
cmp P0, P1
cmovge S1, P0
cmovg P0, P1
cmovge P1, S1
cmp P3, P2
mov S0, P1
cmovge P3, P2
cmovl S2, P2
cmp S0, S2
cmovl S0, S2
cmovle S2, P1
cmp P3, P0
cmovge P2, P3
