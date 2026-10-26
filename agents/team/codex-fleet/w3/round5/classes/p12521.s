# n=5 model=out iset=I1 prefix14_class=12521
mov S0, P3
cmp P1, P3
mov S2, P2
cmovl P3, P1
cmovle P1, S0
cmp P2, P0
cmovge P2, P0
cmovg P0, S2
cmp P2, P3
cmovge S0, P3
cmovge P3, P2
cmovge P2, S0
cmp P1, P0
mov P2, P1
