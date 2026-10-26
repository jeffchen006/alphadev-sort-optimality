# n=5 model=out iset=I1 prefix14_class=14354
mov S0, P2
cmp S0, P3
cmovge P2, P3
cmovle S0, P3
cmp P0, P1
mov S2, P2
cmovle P3, P0
cmovl P0, P1
cmovle P1, P3
cmp P1, P2
cmovge S2, P1
cmovge P1, P2
mov S1, S2
mov P1, S0
