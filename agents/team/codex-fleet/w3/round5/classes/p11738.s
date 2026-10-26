# n=5 model=out iset=I1 prefix14_class=11738
mov S0, P2
cmp P1, P2
cmovge S0, P1
cmovle P2, P1
cmp P3, P0
cmovge P1, P3
cmovg P3, P0
mov S1, S0
cmovg P0, P1
cmp S0, P0
cmovl S1, P0
cmovle P0, S0
cmp P2, P3
cmovle P1, P2
