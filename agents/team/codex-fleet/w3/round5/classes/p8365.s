# n=5 model=out iset=I1 prefix14_class=8365
cmp P1, P2
cmovge S1, P2
cmovl S1, P1
cmovl P1, P2
mov S0, P3
cmp P0, P3
cmovg P3, P0
mov S2, S1
cmovle S0, P0
cmp S2, S0
cmovl S2, S0
cmovg S1, S0
cmp P3, P1
cmovle P0, P3
