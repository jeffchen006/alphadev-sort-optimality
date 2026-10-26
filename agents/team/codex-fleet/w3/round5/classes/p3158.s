# n=5 model=out iset=I1 prefix14_class=3158
cmp P0, P3
cmovge S1, P3
cmovl S1, P0
cmovg P3, P0
mov S2, P2
cmp P2, P1
cmovg P2, P1
cmovg P1, S2
mov S0, P2
cmp P2, S1
cmovg P2, S1
cmovle S0, S1
cmp P1, P3
mov S1, P3
