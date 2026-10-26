# n=5 model=out iset=I1 prefix14_class=12322
cmp P3, P1
cmovge S0, P3
cmovg P3, P1
cmovge P1, S0
mov S1, P2
cmp S1, P0
cmovle S1, P0
cmovl P0, P2
cmp P0, P3
mov P2, P3
cmovle P2, P0
cmovg P3, P0
cmp P1, S1
cmovl P2, S1
