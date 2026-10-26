# n=5 model=out iset=I1 prefix14_class=10444
mov S2, P0
cmp P3, S2
cmovge S2, P3
mov S0, S2
cmovle P0, P3
cmp P1, P2
cmovge S1, P2
cmovl S1, P1
cmovl P1, P2
cmp S2, P1
cmovle S0, P1
cmovl P1, S2
cmp S1, P0
cmovle S0, P0
