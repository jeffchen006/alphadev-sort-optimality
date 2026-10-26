# n=5 model=out iset=I1 prefix14_class=2520
mov S2, P1
mov S1, P2
cmp P0, S2
cmovle S2, P0
cmovl P0, P1
cmp P2, P3
mov P1, P0
cmovle P2, P3
cmovle P3, S1
cmp P1, P2
cmovge P0, P2
cmovg P2, P1
cmp S2, P3
cmovge P1, S2
