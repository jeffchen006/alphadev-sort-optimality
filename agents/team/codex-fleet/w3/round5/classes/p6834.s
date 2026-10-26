# n=5 model=out iset=I1 prefix14_class=6834
cmp P1, P3
cmovle S2, P3
cmovl P3, P1
cmovle P1, S2
cmp P2, P0
mov S1, P2
cmovg S1, P0
cmovl P2, P0
cmovg P0, P2
cmp P1, P2
cmovl P2, P1
cmovl P1, P0
mov P0, S1
cmp P3, S1
