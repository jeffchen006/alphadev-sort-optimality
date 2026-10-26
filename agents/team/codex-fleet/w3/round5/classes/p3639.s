# n=5 model=out iset=I1 prefix14_class=3639
mov S1, P3
cmp S1, P1
cmovl P3, P1
cmovle P1, S1
mov S1, P0
mov S0, P1
cmp P2, P0
cmovl P0, P2
cmovl P2, S1
cmp P0, S0
cmovle S0, P0
cmovge P1, P0
cmp P3, P2
cmovge S1, P3
