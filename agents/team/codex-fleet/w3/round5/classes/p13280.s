# n=5 model=out iset=I1 prefix14_class=13280
cmp P0, P2
cmovge S0, P0
mov S1, P3
cmovg P0, P2
cmovg P2, S0
cmp P3, P1
cmovl P3, P1
cmovge S1, P1
cmp S1, P0
cmovle P1, P0
cmovge P1, S1
cmovge S1, P0
cmp P3, P2
cmovle S2, P2
