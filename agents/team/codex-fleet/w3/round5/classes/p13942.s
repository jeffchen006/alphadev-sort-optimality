# n=5 model=out iset=I1 prefix14_class=13942
cmp P2, P1
mov S0, P2
cmovge S0, P1
cmovle P2, P1
cmp P0, P3
cmovle P1, P3
cmovle P3, P0
cmovle P0, P1
cmp P0, P2
mov S2, P3
cmovge S1, P2
cmovge P2, P0
cmovl S1, P0
cmp S0, P3
