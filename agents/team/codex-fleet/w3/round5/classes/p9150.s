# n=5 model=out iset=I1 prefix14_class=9150
mov S2, P3
cmp P1, S2
cmovl P3, P1
mov S1, P3
cmovg S2, P1
cmp P2, P0
cmovle P1, P0
cmovle P0, P2
cmovl P2, P1
cmp S1, P0
cmovg S1, P0
cmovge P0, P3
cmp P2, S2
cmovl S1, S2
