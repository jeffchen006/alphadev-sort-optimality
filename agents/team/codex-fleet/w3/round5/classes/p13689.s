# n=5 model=out iset=I1 prefix14_class=13689
mov S0, P1
cmp S0, P0
mov S1, P3
cmovl P1, P0
cmovg S0, P0
mov S2, P1
cmp P3, P2
cmovge S1, P2
cmovle P3, P2
cmp P3, S2
cmovge S2, P3
cmovg P3, P1
cmp S0, S1
cmovl P2, S0
