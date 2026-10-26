# n=5 model=out iset=I1 prefix14_class=4716
mov S1, P3
cmp P1, P0
mov S0, P1
cmovge S0, P0
cmovg P0, P1
cmovle P1, P0
cmp P3, P2
cmovl S1, P2
cmovge P3, P2
cmp S1, P0
cmovge P0, S1
cmovge S1, P1
cmp S0, P3
cmovge P2, S0
