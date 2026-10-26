# n=5 model=out iset=I1 prefix14_class=1041
mov S0, P0
cmp S0, P3
cmovl P0, P3
mov S1, P1
cmovle P3, S0
cmp S1, P2
cmovge P1, P2
cmovge P2, S1
cmp P2, P0
cmovge S2, P2
cmovle S2, P0
cmovg P2, P0
cmp P1, P3
cmovge S2, P1
