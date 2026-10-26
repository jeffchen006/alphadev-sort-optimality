# n=5 model=out iset=I1 prefix14_class=12597
mov S0, P1
cmp P2, P1
cmovle S0, P2
cmovle P2, P1
cmp P3, P0
cmovle S1, P0
cmovl P0, P3
cmovle P3, S1
mov P1, S0
cmp P0, P1
cmovle P1, P0
cmovl P0, S0
cmp P3, P2
cmovge S0, P2
