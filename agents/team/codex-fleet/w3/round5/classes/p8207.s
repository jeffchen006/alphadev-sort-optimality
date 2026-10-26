# n=5 model=out iset=I1 prefix14_class=8207
mov S2, P1
cmp P3, P1
cmovl S2, P3
cmovle P3, P1
cmp P2, P0
cmovle S1, P2
cmovl P2, P0
cmovle P0, S1
cmp S2, P0
mov P1, S2
cmovl P1, P0
cmovg S2, P0
mov S2, P2
cmp S2, P3
