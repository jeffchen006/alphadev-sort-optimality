# n=5 model=out iset=I1 prefix14_class=6537
mov S2, P3
cmp P0, P3
cmovge S2, P0
cmovle P3, P0
cmp P1, P2
cmovle P0, P2
cmovle P2, P1
cmovg P0, P1
cmovle P1, P0
cmp P1, S2
cmovg P1, S2
cmovl P0, S2
mov P0, P2
cmovle S2, P1
