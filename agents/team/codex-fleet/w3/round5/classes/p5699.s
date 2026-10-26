# n=5 model=out iset=I1 prefix14_class=5699
mov S0, P0
cmp S0, P3
cmovge S0, P3
cmovg P3, P0
cmovge P0, S0
cmp P1, P2
cmovge S1, P1
cmovg P1, P2
cmovge P2, S1
cmp P1, P0
cmovle P0, P1
cmovl P1, S0
mov P0, P1
cmp P2, P3
