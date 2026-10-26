# n=5 model=out iset=I1 prefix14_class=4355
cmp P1, P2
cmovle S1, P1
cmovl P1, P2
cmovg S1, P2
cmp P3, P0
cmovl S2, P0
cmovle P0, P3
cmovl P3, S2
mov P2, S1
cmp P2, P0
cmovl S1, P0
cmovle P0, P2
mov P0, S1
cmp P3, P1
