# n=5 model=out iset=I1 prefix14_class=2632
cmp P2, P1
mov S2, P0
cmovge S0, P1
cmovg P1, P2
cmovg P2, S0
cmp P3, S2
cmovge P0, P3
cmovle S2, P3
mov S1, P1
cmp P0, S1
cmovle P1, P0
cmovl P0, S1
mov S1, P2
cmp S2, P2
