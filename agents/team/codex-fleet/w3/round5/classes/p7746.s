# n=5 model=out iset=I1 prefix14_class=7746
cmp P1, P3
cmovle S1, P1
cmovl P1, P3
cmovg S1, P3
cmp P0, P2
mov P3, S1
cmovge S0, P2
cmovl S0, P0
cmovg P2, P0
cmp S1, S0
cmovl S1, S0
cmovg P3, S0
cmp P1, P2
cmovle P0, P1
