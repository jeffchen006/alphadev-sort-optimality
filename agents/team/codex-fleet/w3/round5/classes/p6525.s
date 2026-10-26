# n=5 model=out iset=I1 prefix14_class=6525
mov S1, P1
cmp P1, P3
cmovg P1, P3
cmovge P3, S1
cmp P2, P0
mov S1, P0
mov S2, P1
cmovle P0, P2
cmovl P2, S1
cmp P2, P3
cmovle S1, P2
cmovle P2, P3
cmovl P3, S1
cmp P0, P1
