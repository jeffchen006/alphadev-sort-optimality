# n=5 model=out iset=I1 prefix14_class=2655
mov S1, P3
cmp P2, S1
cmovge S1, P2
mov S2, P1
cmovl P3, P2
cmp P1, P0
cmovg P1, P0
cmovl S2, P0
cmovle P0, P1
cmp S1, S2
cmovle S0, S2
cmovle S2, S1
cmovl S1, S0
mov S1, S2
