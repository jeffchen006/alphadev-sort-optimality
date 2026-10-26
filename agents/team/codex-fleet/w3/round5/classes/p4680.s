# n=5 model=out iset=I1 prefix14_class=4680
cmp P3, P2
cmovge S1, P2
cmovge P2, P3
cmovg P3, S1
mov S2, P1
cmp P0, P1
cmovge P1, P0
cmovle S2, P0
mov S0, S2
cmovle P0, P1
cmp P0, P2
cmovg P0, P2
cmovl P1, P2
cmp S2, P3
