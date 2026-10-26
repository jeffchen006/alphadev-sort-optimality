# n=5 model=out iset=I1 prefix14_class=3801
mov S1, P0
cmp P0, P2
cmovg P0, P2
cmovg P2, S1
cmp P3, P1
mov S1, P1
cmovl P1, P3
cmovle P3, S1
cmovle S1, P1
cmp P1, P0
cmovle P1, P0
cmovl P0, S1
cmp P3, P2
mov P0, P1
