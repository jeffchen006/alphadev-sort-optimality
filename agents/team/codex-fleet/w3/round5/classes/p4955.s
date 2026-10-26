# n=5 model=out iset=I1 prefix14_class=4955
cmp P3, P2
mov S2, P3
cmovle S2, P2
mov S1, P0
cmovge P3, P2
cmp P0, P1
cmovle S1, P1
cmovle P1, P0
cmp P3, P1
cmovg P0, P3
cmovge P3, P1
cmovg P1, P0
cmp S2, S1
cmovl P0, S2
