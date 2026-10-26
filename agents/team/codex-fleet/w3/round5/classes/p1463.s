# n=5 model=out iset=I1 prefix14_class=1463
cmp P1, P2
mov S1, P0
cmovge S0, P2
cmovge P2, P1
cmovle S0, P1
cmp S1, P3
cmovge S1, P3
cmovle P0, P3
cmovl P3, S1
cmp P2, P0
mov S2, P0
cmovge S2, P2
cmovg P2, P0
mov S2, P2
