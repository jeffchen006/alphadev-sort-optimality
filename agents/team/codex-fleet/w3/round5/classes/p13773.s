# n=5 model=out iset=I1 prefix14_class=13773
cmp P0, P1
mov S1, P1
mov S2, P3
cmovle P1, P0
cmovle P0, S1
cmp S2, P2
cmovg P3, P2
cmovge P2, S2
cmp P2, P0
cmovle S2, P2
cmovl P2, P0
mov P2, P1
cmovle P0, S2
cmp P3, P2
