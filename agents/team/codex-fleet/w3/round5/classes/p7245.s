# n=5 model=out iset=I1 prefix14_class=7245
cmp P2, P0
mov S1, P0
cmovle S1, P2
cmovge P0, P2
mov P2, P3
cmp P2, P1
cmovle P2, P1
cmovle P1, P3
cmovg P3, P1
cmp P3, S1
cmovl P1, S1
cmovge P3, S1
cmp P2, P0
cmovge P3, P0
