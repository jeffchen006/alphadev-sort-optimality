# n=5 model=out iset=I1 prefix14_class=3306
mov S2, P2
cmp P3, S2
cmovge S2, P3
cmovl P2, P3
cmp P0, P1
mov S1, P0
cmovge P0, P1
cmovle S1, P1
cmp P0, P2
mov S0, P0
cmovle P0, P2
cmovge S0, P2
cmp S2, S1
cmovge P3, S1
