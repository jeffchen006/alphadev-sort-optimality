# n=5 model=out iset=I1 prefix14_class=7475
cmp P1, P3
mov S1, P1
cmovge S1, P3
cmovg P3, P1
cmp P0, P2
cmovle P1, P2
cmovle P2, P0
cmovle P0, P1
cmp P2, S1
cmovle S0, S1
cmovle S1, P2
cmovl P2, S0
cmp P0, P3
mov S1, P2
