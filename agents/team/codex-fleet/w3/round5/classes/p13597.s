# n=5 model=out iset=I1 prefix14_class=13597
mov S0, P1
cmp P2, P3
cmovle S1, P3
cmovge S1, P2
cmovle P3, P2
cmp P0, S0
cmovl P1, P0
cmovle P0, S0
cmp P1, P3
cmovle S2, P3
cmovl P3, P1
mov S0, P0
cmovle P1, S2
mov P3, P1
