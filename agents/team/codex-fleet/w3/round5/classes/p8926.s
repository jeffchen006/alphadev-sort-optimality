# n=5 model=out iset=I1 prefix14_class=8926
cmp P2, P0
cmovle S0, P0
cmovl P0, P2
cmovl P2, S0
mov S1, P1
cmp P3, P1
cmovle S1, P3
cmovg P1, P3
mov P3, P1
cmp P2, P3
cmovle P1, P2
cmovl P2, P3
cmp P0, S1
cmovge P3, S1
