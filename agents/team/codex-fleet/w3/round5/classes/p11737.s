# n=5 model=out iset=I1 prefix14_class=11737
mov S0, P2
cmp P1, P2
cmovge S0, P1
cmovle P2, P1
cmp P0, P3
cmovge P1, P0
cmovg P0, P3
mov S1, S0
cmovg P3, P1
cmp S0, P3
cmovl S1, P3
cmovle P3, S0
cmp P2, P0
cmovle P1, P2
