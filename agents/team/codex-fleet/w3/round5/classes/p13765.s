# n=5 model=out iset=I1 prefix14_class=13765
cmp P0, P2
cmovl S1, P0
cmovge S1, P2
mov S0, P1
cmovle P0, P2
cmp S0, P3
cmovg P1, P3
cmovge P3, S0
cmp P3, P0
cmovle P2, P3
cmovle P3, P0
cmovle P0, P2
mov P3, S1
cmp P1, P3
