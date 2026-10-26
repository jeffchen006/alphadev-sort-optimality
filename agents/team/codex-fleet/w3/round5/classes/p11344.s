# n=5 model=out iset=I1 prefix14_class=11344
mov S0, P0
cmp P1, P0
cmovge P0, P1
cmovge P1, S0
mov S1, P1
mov S2, P2
cmp S2, P3
cmovle P2, P3
cmovge S2, P3
cmp P2, P0
cmovle P3, P2
cmovl P2, P0
cmovle P0, P3
mov S0, P0
