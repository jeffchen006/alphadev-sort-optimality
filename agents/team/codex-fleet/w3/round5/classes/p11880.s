# n=5 model=out iset=I1 prefix14_class=11880
mov S2, P2
cmp P0, P3
cmovge S0, P3
cmovge P3, P0
cmovg P0, S0
cmp P2, P1
cmovle P2, P1
mov S1, P0
cmovge S2, P1
cmp P2, P3
cmovle P1, P2
cmovl P2, P3
cmovle P3, P1
cmp P0, S2
