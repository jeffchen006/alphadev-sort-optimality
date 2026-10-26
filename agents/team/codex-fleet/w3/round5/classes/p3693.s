# n=5 model=out iset=I1 prefix14_class=3693
cmp P0, P2
mov S1, P2
cmovg S1, P0
cmovl P2, P0
cmp P3, P1
cmovle S0, P3
cmovl P3, P1
cmovle P1, S0
mov P0, P2
cmp P2, P1
cmovl P0, P1
cmovle P1, P2
mov P2, P0
mov P1, S1
