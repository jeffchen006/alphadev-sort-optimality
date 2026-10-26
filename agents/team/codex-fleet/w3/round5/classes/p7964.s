# n=5 model=out iset=I1 prefix14_class=7964
cmp P0, P2
mov S2, P2
cmovg P2, P0
cmovge P0, S2
cmp P3, P1
cmovge S2, P3
cmovle S2, P1
cmovge P3, P1
mov P1, P3
cmp P1, P0
cmovle P1, P0
cmovl P0, P3
cmp S2, P2
cmovle S0, S2
