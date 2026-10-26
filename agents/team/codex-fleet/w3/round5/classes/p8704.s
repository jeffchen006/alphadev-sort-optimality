# n=5 model=out iset=I1 prefix14_class=8704
cmp P2, P0
cmovle S2, P0
cmovge S2, P2
cmovle P0, P2
cmp P1, P3
cmovge P2, P1
cmovg P1, P3
cmovg P3, P2
cmp S2, P3
cmovle P2, P3
cmovl P3, S2
mov S0, P0
cmovle S2, P2
cmp P1, P0
