# n=5 model=out iset=I1 prefix14_class=11936
cmp P0, P2
cmovge S2, P0
cmovl S2, P2
cmovl P2, P0
cmp P3, P1
mov S0, P3
cmovl P3, P1
cmovle P1, S0
cmp S2, P3
cmovge S0, S2
cmovg S2, P3
cmovg P3, S0
cmp P2, P1
cmovle S0, P2
