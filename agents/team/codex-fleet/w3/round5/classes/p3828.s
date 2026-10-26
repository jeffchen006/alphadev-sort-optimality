# n=5 model=out iset=I1 prefix14_class=3828
cmp P1, P2
mov S2, P1
cmovge S2, P2
cmovge P2, P1
cmp P0, P3
mov P1, P3
cmovg P1, P0
cmovl P3, P0
cmp P3, S2
mov S0, S2
cmovge S0, P3
cmovl S2, P3
cmp P2, P1
cmovle P3, P1
