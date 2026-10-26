# n=5 model=out iset=I1 prefix14_class=13021
cmp P3, P0
cmovle S1, P3
cmovg S1, P0
mov S2, P2
cmovle P3, P0
cmp P1, S2
cmovg P2, P1
cmovg P1, S2
cmp P1, S1
cmovl S2, P1
cmovle P1, S1
cmovl S1, S2
mov P0, P3
cmp P2, P0
