# n=5 model=out iset=I1 prefix14_class=11251
cmp P1, P3
mov S2, P0
mov S0, P1
cmovl P1, P3
cmovge S0, P3
cmp S2, P2
cmovle S2, P2
cmovg P0, P2
cmp P1, S2
cmovge P3, S2
cmovge S2, P1
cmovge P1, P3
cmp P0, S0
cmovle P2, P0
