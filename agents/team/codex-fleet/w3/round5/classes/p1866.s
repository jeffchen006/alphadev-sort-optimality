# n=5 model=out iset=I1 prefix14_class=1866
cmp P2, P3
mov S2, P3
mov S1, P0
cmovl S2, P2
cmovg P3, P2
mov P2, P3
cmp P1, S1
cmovle S1, P1
cmovg P0, P1
cmp P0, P3
cmovl P2, P0
cmovl P0, P3
cmp S1, S2
cmovle P3, P2
