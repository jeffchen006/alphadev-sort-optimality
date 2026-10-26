# n=5 model=out iset=I1 prefix14_class=13859
cmp P3, P1
mov S2, P3
cmovge P3, P1
cmovg P1, S2
cmp P0, P2
cmovge S0, P0
cmovge P0, P2
cmovge P2, S0
cmp P1, P2
mov S1, P2
cmovg P2, P1
cmovle S1, P1
cmp P0, P3
cmovl S0, P0
