# n=5 model=out iset=I1 prefix14_class=8800
mov S2, P1
cmp P1, P0
cmovge S2, P0
cmovge P0, P1
cmp P3, P2
cmovg P1, P3
cmovle P1, P2
cmovle P2, P3
cmp P1, P0
cmovge P3, P0
cmovl P3, P1
cmovle P1, P0
cmp S2, P2
cmovge S0, P2
