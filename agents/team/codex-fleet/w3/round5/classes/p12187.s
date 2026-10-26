# n=5 model=out iset=I1 prefix14_class=12187
cmp P1, P0
mov S0, P1
cmovge S0, P0
cmovl P1, P0
mov S1, P2
cmp P3, P2
cmovg P2, P3
cmovle S1, P3
cmp S0, S1
cmovle P0, S0
cmovle S0, S1
cmovl S1, P0
cmp P2, P1
mov S2, P1
