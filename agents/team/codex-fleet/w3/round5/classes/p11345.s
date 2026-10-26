# n=5 model=out iset=I1 prefix14_class=11345
mov S0, P0
cmp P1, P0
cmovg P0, P1
cmovg P1, S0
mov S2, P3
cmp S2, P2
cmovl P3, P2
mov S1, P1
cmovge S2, P2
cmp P3, P0
cmovl P2, P3
cmovle P3, P0
cmovl P0, P2
cmp S1, S2
