# n=5 model=out iset=I1 prefix14_class=4715
mov S0, P1
cmp P1, P2
mov S1, P3
cmovge S0, P2
cmovge P2, P1
cmovle P1, P2
cmp P3, P0
cmovl S1, P0
cmovge P3, P0
cmp S1, P1
cmovge P1, S1
cmovge S1, P2
cmp S0, P3
cmovge P0, S0
