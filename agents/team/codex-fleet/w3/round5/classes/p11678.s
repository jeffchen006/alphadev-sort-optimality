# n=5 model=out iset=I1 prefix14_class=11678
cmp P3, P2
cmovle S1, P2
mov S0, P1
cmovl P2, P3
cmovle P3, S1
cmp P0, P1
cmovle S0, P0
cmovl P0, P1
cmovg P1, P0
cmp P3, P1
cmovl P0, P3
cmovl P3, P1
cmp P2, S0
cmovle S1, S0
