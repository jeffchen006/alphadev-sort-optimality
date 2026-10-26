# n=5 model=out iset=I1 prefix14_class=10648
cmp P1, P2
cmovle S2, P1
cmovle P1, P2
cmovle P2, S2
cmp P0, P3
mov S1, P1
cmovl S0, P3
cmovge S0, P0
cmovge P0, P3
cmp S1, S0
cmovg S1, S0
cmovl P1, S0
cmp P0, P2
mov S0, S1
