# n=5 model=out iset=I1 prefix14_class=2537
cmp P1, P0
mov S2, P0
cmovle P0, P1
cmovl P1, S2
cmp P3, P2
cmovle S0, P3
cmovl P3, P2
cmovle P2, S0
mov S1, P1
cmp P1, P3
cmovl P1, P3
cmovge S1, P3
mov P1, P0
cmp P0, P2
