# n=5 model=out iset=I1 prefix14_class=1924
cmp P1, P3
cmovle S1, P3
cmovl P3, P1
cmovle P1, S1
cmp P0, P2
cmovle S2, P2
cmovle P2, P0
cmovle P0, S2
mov S2, P1
cmp P0, P1
cmovge P1, P0
cmovle S2, P0
mov P0, P3
cmp P3, P2
