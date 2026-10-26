# n=5 model=out iset=I1 prefix14_class=9084
cmp P1, P0
mov S1, P1
cmovl P1, P0
cmovle P0, S1
mov S2, P2
cmp S2, P3
cmovle P2, P3
cmovge S2, P3
cmp P0, S2
mov S0, P0
cmovge P0, S2
cmovle S0, S2
cmp P1, P2
cmovle P3, P1
