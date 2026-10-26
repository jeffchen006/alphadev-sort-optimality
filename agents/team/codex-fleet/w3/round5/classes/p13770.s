# n=5 model=out iset=I1 prefix14_class=13770
cmp P2, P1
cmovle S2, P1
mov S1, P3
cmovl P1, P2
cmovle P2, S2
cmp P3, P0
cmovg P3, P0
cmovge P0, S1
cmp P0, P2
mov S1, P0
cmovle P0, P2
mov P0, P1
cmovle P2, S1
cmp P3, P0
