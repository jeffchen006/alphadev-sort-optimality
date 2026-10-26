# n=5 model=out iset=I1 prefix14_class=7135
cmp P1, P2
mov S2, P2
mov S0, P0
cmovle P2, P1
cmovl P1, S2
cmp P0, P3
cmovle P0, P3
cmovge S0, P3
cmp P2, S0
mov S2, S0
cmovge S2, P2
cmovg P2, S0
cmp P1, P0
cmovge P3, P1
