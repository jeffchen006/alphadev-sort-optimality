# n=5 model=out iset=I1 prefix14_class=9571
cmp P1, P3
cmovle S1, P1
cmovle P1, P3
cmovle P3, S1
cmp P2, P0
mov S2, P2
cmovge P2, P0
cmovl S2, P0
mov P0, P1
cmp P1, S2
cmovl P0, S2
cmovg P1, S2
mov P0, P3
mov S2, P1
