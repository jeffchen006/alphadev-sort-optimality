# n=5 model=out iset=I1 prefix14_class=5759
mov S1, P1
cmp P3, P2
cmovge S2, P2
cmovge P2, P3
cmovg P3, S2
cmp P0, P1
cmovge S1, P0
mov S0, P3
cmovle P1, P0
cmp P1, S0
cmovg P3, P1
cmovl S0, P1
cmp P2, S1
cmovle S2, P2
