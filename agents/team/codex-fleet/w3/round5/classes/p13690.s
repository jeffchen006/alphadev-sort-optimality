# n=5 model=out iset=I1 prefix14_class=13690
mov S0, P1
mov S1, P2
cmp S0, P0
cmovge S0, P0
cmovl P1, P0
mov S2, P1
cmp P2, P3
cmovge S1, P3
cmovle P2, P3
cmp P2, P1
cmovge P1, P2
cmovg P2, S2
cmp S0, S1
cmovl P3, S0
