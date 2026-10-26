# n=5 model=out iset=I1 prefix14_class=2643
cmp P2, P3
mov S2, P3
mov S0, P0
cmovge S2, P2
cmovg P2, P3
cmovge P3, S2
cmp P1, S0
cmovl S0, P1
cmovg P0, P1
cmp P0, S2
cmovle S2, P0
cmovle P0, P3
cmp P2, S0
cmovle S1, P2
