# n=5 model=out iset=I1 prefix14_class=7668
mov S0, P0
cmp P3, S0
mov S1, P2
cmovl P0, P3
cmovl P3, S0
cmp P1, P2
cmovg P2, P1
cmovge P1, S1
cmp P0, P1
cmovle S0, P0
cmovle P0, P1
mov S1, P3
cmovle P1, S0
mov P1, P0
