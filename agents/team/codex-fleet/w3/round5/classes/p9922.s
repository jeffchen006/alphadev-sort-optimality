# n=5 model=out iset=I1 prefix14_class=9922
mov S2, P3
cmp P2, S2
mov S0, P0
cmovge S2, P2
cmovg P2, P3
cmp S0, P1
cmovl S0, P1
cmovle P1, P0
cmp S0, S2
cmovge P3, S2
cmovge S2, S0
cmovge S0, P3
mov S1, P1
cmp S1, P2
