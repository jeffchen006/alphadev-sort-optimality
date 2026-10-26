# n=5 model=out iset=I1 prefix14_class=123
cmp P0, P3
cmovle S2, P3
cmovg S2, P0
cmovg P0, P3
mov P3, P1
cmp P2, P3
cmovge P3, P2
cmovle P1, P2
cmp P1, P0
cmovle S1, P0
cmovl P0, P1
cmovl P1, S1
cmp S2, P3
mov P2, P3
