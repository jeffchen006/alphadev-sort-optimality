# n=5 model=out iset=I1 prefix14_class=3671
cmp P0, P2
cmovle S2, P2
cmovg S2, P0
cmovle P2, P0
cmp P3, P1
cmovl S1, P3
cmovle P3, P1
mov P0, P2
cmovl P1, S1
cmp P2, P1
cmovle P0, P1
cmovle P1, P2
mov P2, P3
cmp S2, P2
