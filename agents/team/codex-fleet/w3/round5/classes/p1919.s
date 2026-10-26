# n=5 model=out iset=I1 prefix14_class=1919
mov S2, P3
cmp P0, P3
cmovle S2, P0
cmovl P0, P3
cmp P2, P1
cmovge P3, P2
cmovl P3, P1
cmovle P1, P2
cmp P0, P3
cmovle P2, P0
cmovle P0, P3
cmovg P2, P3
mov P0, P2
cmp P1, S2
