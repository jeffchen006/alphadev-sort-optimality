# n=5 model=out iset=I1 prefix14_class=12000
mov S2, P3
mov S1, P0
cmp P1, P0
cmovg P0, P1
cmovge P1, S1
cmp P3, P2
cmovle S2, P2
cmovle P2, P3
cmp P2, P1
cmovle S1, P1
cmovl P1, P2
cmovl P2, S1
mov P1, P2
cmp S2, P0
