# n=5 model=out iset=I1 prefix14_class=11876
mov S1, P1
cmp P0, S1
mov S0, P3
cmovl S1, P0
cmovge P1, P0
cmp P3, P2
cmovg P3, P2
cmovle S0, P2
cmp S0, P1
cmovl P0, S0
cmovle S0, P1
cmovl P1, P0
mov S0, P3
cmp P3, S1
