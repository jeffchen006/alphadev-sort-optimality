# n=5 model=out iset=I1 prefix14_class=2609
cmp P3, P2
mov S1, P2
cmovge P2, P3
mov S0, P1
cmovg P3, S1
cmp P0, S0
cmovge S0, P0
cmovg P0, P1
cmp S0, P2
cmovge P1, P2
cmovle P1, S0
cmovl S0, P2
cmp P3, P0
cmovge S1, P0
