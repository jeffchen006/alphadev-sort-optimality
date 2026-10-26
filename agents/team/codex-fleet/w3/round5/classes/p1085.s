# n=5 model=out iset=I1 prefix14_class=1085
mov S2, P1
mov S1, P0
cmp P3, S1
cmovg S1, P3
cmovle P0, P3
cmp P1, P2
mov S0, P0
cmovl P1, P2
cmovge S2, P2
cmovg P2, P1
cmp S1, P2
cmovl P1, S1
cmovg P2, S1
cmp S2, S0
