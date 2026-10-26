# n=5 model=out iset=I1 prefix14_class=3802
mov S1, P0
cmp P0, P3
cmovg P0, P3
cmovge P3, S1
cmp P1, P2
cmovle S1, P2
cmovl P2, P1
cmovle P1, S1
mov S1, P2
cmp P2, P0
cmovle P2, P0
cmovl P0, S1
cmp P3, P1
mov P0, P2
