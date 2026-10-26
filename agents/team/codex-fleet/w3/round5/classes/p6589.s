# n=5 model=out iset=I1 prefix14_class=6589
mov S1, P0
cmp P2, P0
mov S2, P1
cmovg S1, P2
cmovl P0, P2
cmp S2, P3
cmovl S2, P3
mov S0, S1
cmovle P3, P1
cmp S1, S2
cmovge S0, S2
cmovg S2, S1
cmp P3, P0
cmovl S1, P3
