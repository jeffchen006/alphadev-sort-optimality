# n=5 model=out iset=I1 prefix14_class=12775
cmp P0, P3
cmovge S2, P3
cmovg P3, P0
cmovg P0, S2
mov S1, P1
cmp P2, P1
cmovg S1, P2
cmovl P1, P2
cmp P1, P0
cmovle S2, P0
cmovle P0, P1
mov P2, S1
cmovle P1, S2
cmp P3, P2
