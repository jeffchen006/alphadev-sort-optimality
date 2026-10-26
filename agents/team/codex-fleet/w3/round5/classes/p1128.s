# n=5 model=out iset=I1 prefix14_class=1128
mov S2, P0
cmp P3, P0
cmovle P0, P3
cmovge S2, P3
mov P3, P2
cmp P1, P3
cmovg P2, P1
cmovg P1, P3
cmp S2, P2
mov S1, P2
cmovg S1, S2
cmovl P2, S2
cmp P0, P1
cmovle S2, P1
