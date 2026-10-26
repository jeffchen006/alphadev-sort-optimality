# n=5 model=out iset=I1 prefix14_class=4898
mov S1, P2
cmp P2, P1
cmovle S1, P1
mov S2, P3
cmovle P1, P2
cmp P0, S2
cmovl S2, P0
cmovl P0, P3
cmp S2, P1
cmovge P2, S2
cmovge S2, P1
cmovle P2, P1
cmp S1, P0
cmovle P3, S1
