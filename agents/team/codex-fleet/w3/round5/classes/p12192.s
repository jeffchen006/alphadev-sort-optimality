# n=5 model=out iset=I1 prefix14_class=12192
mov S1, P2
cmp P2, P1
cmovg P2, P1
cmovl S1, P1
mov P1, P0
cmp P0, P3
cmovl P1, P3
cmovg P0, P3
cmp P0, P2
cmovle S2, P2
cmovg S2, P0
cmovle P2, P0
cmp P1, S1
cmovle P2, P1
