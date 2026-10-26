# n=5 model=out iset=I1 prefix14_class=11518
mov S2, P1
cmp P0, S2
cmovl P1, P0
cmovle P0, S2
mov S2, P3
cmp P2, S2
cmovl S2, P2
cmovle P2, P3
mov P3, P1
cmp P3, S2
cmovl P3, S2
cmovl S2, P1
cmp P2, P0
cmovg S1, P2
