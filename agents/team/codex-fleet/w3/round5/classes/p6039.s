# n=5 model=out iset=I1 prefix14_class=6039
mov S2, P2
cmp P1, P3
cmovle S0, P3
cmovl P3, P1
cmovge S0, P1
mov P1, S0
cmp P0, P2
cmovle S2, P0
cmovle P0, P2
cmp P0, S0
cmovge P1, P0
cmovl S0, P0
cmp S2, P3
cmovl P0, S2
