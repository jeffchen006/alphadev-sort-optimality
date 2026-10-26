# n=5 model=out iset=I1 prefix14_class=5713
cmp P1, P2
cmovle S0, P2
cmovle P2, P1
cmovge S0, P1
mov P1, P0
cmp P3, P1
cmovge P0, P3
cmovl P1, P3
cmp P1, P2
cmovge S1, P2
cmovg P2, P1
cmovg P1, S1
cmp S0, P0
cmovle S1, P0
