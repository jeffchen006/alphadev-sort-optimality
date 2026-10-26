# n=5 model=out iset=I1 prefix14_class=11201
cmp P1, P2
mov S0, P0
cmovge S1, P2
cmovg P2, P1
cmovg P1, S1
cmp S0, P3
cmovge P0, P3
cmovl S0, P3
cmovle P3, P0
cmp S0, P2
mov S2, P2
cmovg S2, S0
cmovl P2, S0
cmp P1, P0
