# n=5 model=out iset=I1 prefix14_class=6793
mov S2, P2
cmp S2, P0
cmovle P2, P0
mov S0, P3
cmovl P0, S2
mov S1, P2
cmp S0, P1
cmovge S0, P1
cmovle P3, P1
cmp P3, S1
cmovle P2, P3
cmovge S1, P3
cmp S0, P0
cmovge S2, P0
