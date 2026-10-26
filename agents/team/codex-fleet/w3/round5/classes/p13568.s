# n=5 model=out iset=I1 prefix14_class=13568
cmp P2, P1
cmovl S2, P2
cmovl P2, P1
mov S1, P3
cmovl P1, S2
cmp P0, P3
cmovle P3, P0
cmovle P0, S1
mov S1, P1
cmp P3, S1
cmovge P1, P3
cmovg P3, S1
cmp P2, P0
cmovl S1, P1
