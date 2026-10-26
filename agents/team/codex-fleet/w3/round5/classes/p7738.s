# n=5 model=out iset=I1 prefix14_class=7738
cmp P1, P3
mov S0, P0
cmovge S2, P1
cmovl S2, P3
cmovl P3, P1
cmp S0, P2
cmovg S0, P2
cmovg P2, P0
mov S1, P3
cmp S0, P3
cmovle S1, S0
cmovl S0, P3
cmp P2, S2
cmovle P0, P2
