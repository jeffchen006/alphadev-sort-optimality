# n=5 model=out iset=I1 prefix14_class=9560
cmp P1, P0
cmovle S0, P0
cmovle P0, P1
cmovle P1, S0
mov S2, P3
cmp S2, P2
cmovge S2, P2
cmovge P2, P3
cmp S2, P0
cmovge S1, P0
cmovle S1, S2
cmovg P0, S2
cmp P1, P2
cmovl S2, P2
