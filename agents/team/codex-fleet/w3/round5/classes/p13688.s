# n=5 model=out iset=I1 prefix14_class=13688
mov S1, P2
mov S0, P3
cmp P2, P0
cmovl P2, P0
mov S2, P2
cmovg S1, P0
cmp P3, P1
cmovge S0, P1
cmovl P3, P1
cmp P3, S2
cmovge S2, P3
cmovg P3, P2
cmp S1, S0
cmovle P1, S1
