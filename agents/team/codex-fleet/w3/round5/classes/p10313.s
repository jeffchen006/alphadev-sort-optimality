# n=5 model=out iset=I1 prefix14_class=10313
cmp P2, P0
mov S2, P2
cmovge S2, P0
mov S0, P3
cmovg P0, P2
cmp P3, P1
cmovge P3, P1
mov S1, P0
cmovle S0, P1
cmp P0, S0
cmovg P0, S0
cmovl S1, S0
cmp P3, S2
cmovle S1, P3
