# n=5 model=out iset=I1 prefix14_class=5961
cmp P1, P0
mov S2, P1
cmovle S2, P0
cmovle P0, P1
mov P1, P3
cmp P1, P2
cmovg P3, P2
cmovl P1, P2
mov P2, P1
cmp P2, S2
cmovle P2, S2
cmovg P1, S2
cmp P3, P0
mov S2, P0
