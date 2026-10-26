# n=5 model=out iset=I1 prefix14_class=10338
cmp P0, P3
cmovle S1, P3
cmovg S1, P0
mov S0, P2
cmovl P3, P0
cmp P2, P1
cmovle P2, P1
cmovl P1, S0
cmp S1, P2
cmovge S0, S1
cmovge S1, P2
cmovg P2, S0
mov P0, P1
cmp P1, P3
