# n=5 model=out iset=I1 prefix14_class=11732
mov S1, P2
cmp P3, S1
cmovle P2, P3
cmovge S1, P3
cmp P1, P0
mov S0, P1
cmovg P1, P0
cmovge P0, S0
mov S2, S1
cmp S2, P0
cmovl S1, P0
cmovge S2, P0
cmp P2, P1
cmovle S0, P1
