# n=5 model=out iset=I1 prefix14_class=13306
cmp P1, P3
cmovle S1, P3
cmovge S1, P1
cmovle P3, P1
mov S0, P2
cmp P0, P2
cmovl P2, P0
cmovle P0, S0
cmp P3, P2
cmovge S0, P3
mov P1, S1
cmovge P3, P2
cmovge P2, S0
cmp S1, P0
