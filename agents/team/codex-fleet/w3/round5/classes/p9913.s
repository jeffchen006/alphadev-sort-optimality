# n=5 model=out iset=I1 prefix14_class=9913
cmp P1, P3
mov S1, P0
cmovge S0, P1
cmovge P1, P3
cmovg P3, S0
mov S2, P3
cmp P0, P2
cmovge S1, P2
cmovle P0, P2
cmp P0, P3
cmovl P3, P0
cmovge S2, P0
cmp S1, P1
mov P0, S1
