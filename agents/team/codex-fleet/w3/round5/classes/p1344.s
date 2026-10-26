# n=5 model=out iset=I1 prefix14_class=1344
cmp P1, P3
mov S1, P1
cmovle S1, P3
mov S0, P2
cmovl P3, P1
cmp P0, P2
mov P1, S1
cmovl P2, P0
cmovge S0, P0
cmp S0, P1
cmovge S1, S0
mov S1, P2
cmovl P1, S0
cmp S1, P3
