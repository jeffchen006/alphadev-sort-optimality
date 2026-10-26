# n=5 model=out iset=I1 prefix14_class=12002
mov S1, P2
cmp P1, P2
mov S2, P3
cmovg P2, P1
cmovge P1, S1
cmp P3, P0
cmovle S2, P0
cmovle P0, P3
cmp P0, P1
cmovle S1, P1
cmovl P1, P0
cmovl P0, S1
mov P1, P0
cmp P2, S2
