# n=5 model=out iset=I1 prefix14_class=6081
cmp P3, P0
cmovle S1, P3
cmovle P3, P0
cmovl P0, S1
cmp P1, P2
mov S1, P1
cmovle S1, P2
cmovge P1, P2
cmp S1, P3
cmovg P2, S1
cmovge S1, P3
cmovg P3, P2
cmp P1, P0
cmovge P3, P1
