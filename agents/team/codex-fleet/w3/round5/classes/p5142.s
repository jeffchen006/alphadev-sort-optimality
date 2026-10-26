# n=5 model=out iset=I1 prefix14_class=5142
mov S1, P2
cmp P3, P0
mov S0, P3
cmovl P3, P0
cmovle P0, S0
cmp P1, S1
cmovl P2, P1
cmovl P1, S1
cmp P0, P2
cmovg S0, P0
cmovge P0, P2
cmovg P2, S0
cmp P3, P1
cmovg S0, P1
