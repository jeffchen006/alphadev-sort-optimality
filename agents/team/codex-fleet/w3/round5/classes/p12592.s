# n=5 model=out iset=I1 prefix14_class=12592
cmp P2, P0
cmovle S2, P0
cmovg S2, P2
cmovle P0, P2
mov S1, P1
cmp P3, P1
cmovle P1, P3
cmovle P3, S1
cmp P0, P1
cmovle P2, P1
mov S1, S2
cmovl P1, P0
cmovl P0, P2
mov P1, P0
