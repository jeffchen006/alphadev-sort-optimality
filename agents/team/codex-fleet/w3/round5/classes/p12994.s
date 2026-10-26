# n=5 model=out iset=I1 prefix14_class=12994
mov S0, P2
mov S2, P1
cmp P2, P3
cmovle P2, P3
cmovl P3, S0
cmp P0, P1
cmovle P1, P0
cmovle P0, S2
cmp P1, P3
cmovge S0, P3
cmovge P3, P1
mov S1, P0
cmovg P1, S0
cmp S1, P2
