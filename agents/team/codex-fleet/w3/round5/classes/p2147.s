# n=5 model=out iset=I1 prefix14_class=2147
cmp P1, P2
mov S1, P1
cmovge S1, P2
cmovle P1, P2
cmp P3, P0
cmovle P2, P0
cmovl P0, P3
cmovl P3, P2
cmp P3, P1
cmovge S0, P1
cmovle S0, P3
cmovge P1, P3
mov P3, S1
cmp S1, P0
