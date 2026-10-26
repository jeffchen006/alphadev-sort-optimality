# n=5 model=out iset=I1 prefix14_class=11057
mov S1, P1
cmp P3, S1
cmovl P1, P3
mov S0, P2
cmovge S1, P3
cmp S0, P0
cmovge S0, P0
cmovge P0, P2
cmp P0, S1
cmovge P3, P0
cmovle P3, S1
cmovle S1, P0
cmp S0, P1
cmovge P0, S1
