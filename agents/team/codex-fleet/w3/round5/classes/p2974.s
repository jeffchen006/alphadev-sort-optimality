# n=5 model=out iset=I1 prefix14_class=2974
cmp P0, P1
mov S2, P1
cmovl P1, P0
cmovge S2, P0
mov S1, P3
cmp S1, P2
cmovg P3, P2
cmovg P2, S1
cmp P2, S2
cmovle P0, S2
cmovle S2, P2
cmovle P2, P0
mov P2, P1
cmp P3, P1
