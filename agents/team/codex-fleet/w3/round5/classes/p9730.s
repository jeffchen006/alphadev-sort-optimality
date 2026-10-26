# n=5 model=out iset=I1 prefix14_class=9730
mov S2, P2
cmp P1, P2
cmovg S2, P1
cmovle P2, P1
cmp P3, P0
cmovle S1, P0
cmovl P0, P3
cmovl P3, S1
cmp S2, P3
mov P1, P3
cmovle P1, S2
cmovg P3, S2
cmp P2, P0
cmovge S2, P2
