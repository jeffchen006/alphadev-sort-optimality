# n=5 model=out iset=I1 prefix14_class=9298
mov S0, P1
cmp S0, P0
cmovge S0, P0
cmovg P0, P1
cmp P2, P3
cmovl P1, P3
mov S2, S0
cmovle P3, P2
cmovl P2, P1
cmp P3, S0
cmovge S0, P3
cmovl S2, P3
mov S2, S0
mov P3, P0
