# n=5 model=out iset=I1 prefix14_class=886
cmp P3, P0
cmovl S0, P0
cmovle P0, P3
cmovl P3, S0
cmp P2, P1
mov S1, P2
mov S2, P0
cmovg P2, P1
mov S0, P3
cmovge P1, S1
cmp P1, S0
cmovl P3, P1
cmovge S0, P1
cmp S2, P2
