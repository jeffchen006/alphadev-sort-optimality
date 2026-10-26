# n=5 model=out iset=I1 prefix14_class=7010
mov S2, P1
cmp P3, P0
cmovle S1, P0
cmovl P0, P3
cmovl P3, S1
cmp S2, P2
cmovle S2, P2
cmovle P2, P1
cmp P2, P0
cmovg P1, P2
cmovle P1, P0
cmovg P2, P0
cmp P3, S2
mov P0, P1
