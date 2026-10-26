# n=5 model=out iset=I1 prefix14_class=7250
cmp P2, P1
mov S1, P1
cmovle P1, P2
cmovge S1, P2
cmp P3, P0
cmovle P2, P0
cmovl P0, P3
mov S2, P0
cmovl P3, P2
cmp P0, P1
cmovle S2, P1
cmovg P0, P1
cmp S1, P3
mov P0, S1
