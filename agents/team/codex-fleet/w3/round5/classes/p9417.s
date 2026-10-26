# n=5 model=out iset=I1 prefix14_class=9417
mov S0, P2
cmp P3, P2
cmovge S0, P3
mov S1, P0
cmovge P3, P2
cmp P1, P0
cmovle P0, P1
cmovl P1, S1
cmp P0, P3
cmovge S2, P0
cmovge P0, P3
cmovg P3, S2
cmp S0, P1
cmovle S1, P1
