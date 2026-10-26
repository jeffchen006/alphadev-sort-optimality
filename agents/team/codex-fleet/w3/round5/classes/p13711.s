# n=5 model=out iset=I1 prefix14_class=13711
mov S1, P3
cmp P3, P0
cmovge S1, P0
cmovl P3, P0
cmp P2, P1
cmovg P0, P2
cmovle P0, P1
cmovge P2, P1
cmp P2, S1
cmovle P1, P2
cmovl P2, S1
cmovle S1, P1
mov S1, P0
cmp S1, P3
