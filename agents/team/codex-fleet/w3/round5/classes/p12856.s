# n=5 model=out iset=I1 prefix14_class=12856
mov S0, P2
mov S1, P0
cmp P3, S0
cmovle S0, P3
cmovg P2, P3
cmovle P3, P2
cmp S1, P1
cmovl S1, P1
cmovge P0, P1
cmp S0, P0
cmovle S2, S0
cmovl S0, P0
cmovl P0, S2
mov P1, S0
