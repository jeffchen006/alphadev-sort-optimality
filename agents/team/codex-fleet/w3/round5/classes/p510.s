# n=5 model=out iset=I1 prefix14_class=510
cmp P3, P0
cmovge S2, P0
cmovge P0, P3
cmovl S2, P3
mov S0, P1
cmp P1, P2
cmovg P1, P2
cmovg P2, S0
mov S1, S2
cmp P1, S1
cmovle S2, P1
cmovle P1, S1
cmp P0, P2
cmovge S0, P0
