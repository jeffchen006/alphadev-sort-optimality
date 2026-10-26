# n=5 model=out iset=I1 prefix14_class=12937
mov S2, P2
cmp S2, P1
cmovg S2, P1
cmovl P2, P1
mov P1, S2
cmp P0, P3
cmovle S1, P3
cmovle P3, P0
cmovle P0, S1
cmp P1, P3
cmovle P1, P3
cmovge S2, P3
cmp P0, P2
cmovle P3, P2
