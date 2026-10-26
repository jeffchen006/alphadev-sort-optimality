# n=5 model=out iset=I1 prefix14_class=7383
mov S1, P3
cmp P3, P2
cmovl P3, P2
cmovle P2, S1
cmovle S1, P3
mov S0, P1
cmp S0, P0
cmovge P1, P0
cmovge P0, S0
cmp P2, P1
cmovge S2, P1
cmovg P1, P2
cmovg P2, S2
cmp P0, S1
