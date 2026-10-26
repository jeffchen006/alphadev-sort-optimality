# n=5 model=out iset=I1 prefix14_class=1039
mov S0, P0
cmp S0, P2
cmovl P0, P2
mov S1, P1
cmovle P2, S0
cmp S1, P3
cmovge P1, P3
cmovge P3, S1
cmp P3, P0
cmovge S2, P3
cmovle S2, P0
cmovg P3, P0
cmp P2, P1
cmovge S2, P2
