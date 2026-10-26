# n=5 model=out iset=I1 prefix14_class=10437
cmp P1, P2
mov S1, P2
cmovl P2, P1
cmovge S1, P1
cmp P3, P0
mov P1, P3
cmovle P1, P0
cmovl P0, P3
cmp P1, S1
cmovg S0, S1
cmovle S0, P1
cmovl P1, S1
cmp P0, P2
cmovle S1, S0
