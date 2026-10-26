# n=5 model=out iset=I1 prefix14_class=1072
mov S0, P3
mov S2, P1
cmp S2, P0
cmovle P1, P0
cmovl P0, S2
cmp P3, P2
cmovg S0, P2
cmovg P2, P3
mov S2, P0
cmp P2, P1
cmovge S1, P2
cmovg P2, P1
cmovg P1, S1
cmp S0, S2
