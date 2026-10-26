# n=5 model=out iset=I1 prefix14_class=4287
mov S0, P1
cmp S0, P0
cmovl P1, P0
cmovge S0, P0
cmp P2, P3
cmovle P0, P2
cmovle P2, P3
cmovg P0, P3
cmp S0, P0
cmovg P3, S0
cmovle P3, P0
cmovl P0, S0
cmp P2, P1
cmovge P0, P2
