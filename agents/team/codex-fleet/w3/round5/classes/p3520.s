# n=5 model=out iset=I1 prefix14_class=3520
cmp P1, P3
cmovge S2, P1
cmovge P1, P3
cmovge P3, S2
mov S0, P0
cmp S0, P2
mov S2, P3
mov S1, P1
cmovle S0, P2
cmovl P2, P0
cmp P2, S1
cmovge S1, P2
cmovle P1, P2
mov P2, S1
