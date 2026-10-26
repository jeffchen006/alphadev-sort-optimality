# n=5 model=out iset=I1 prefix14_class=12646
mov S2, P0
cmp P2, S2
cmovge P0, P2
mov S1, P1
cmovle S2, P2
cmp P3, S1
cmovle S1, P3
cmovl P3, P1
cmp S2, S1
cmovle P2, S1
cmovl S1, S2
cmovl S2, P2
cmp P0, P3
cmovle P2, P0
