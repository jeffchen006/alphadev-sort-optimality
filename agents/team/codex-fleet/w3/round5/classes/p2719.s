# n=5 model=out iset=I1 prefix14_class=2719
mov S2, P1
cmp P1, P3
cmovl P1, P3
cmovl P3, S2
mov S1, P2
cmp P2, P0
cmovl S1, P0
cmovl P0, P2
cmp P1, S1
mov P2, S1
cmovle S1, P1
cmovle P1, P2
cmp P0, P3
cmovle S2, P3
