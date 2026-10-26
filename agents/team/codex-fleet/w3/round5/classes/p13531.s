# n=5 model=out iset=I1 prefix14_class=13531
cmp P1, P3
cmovle S1, P1
cmovl P1, P3
cmovg S1, P3
cmp P2, P0
mov P3, P0
cmovle P3, P2
cmovl P2, P0
cmp P3, S1
cmovle P0, P3
cmovl P3, S1
cmovle S1, P0
mov S1, P2
cmp P2, P1
