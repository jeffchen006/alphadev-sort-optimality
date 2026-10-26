# n=5 model=out iset=I1 prefix14_class=3867
cmp P2, P3
cmovle S0, P2
cmovge S0, P3
mov S2, S0
cmovge P3, P2
cmp P0, P1
cmovge P2, P0
cmovl P2, P1
cmovl P1, P0
cmp S2, P1
cmovle S0, P1
cmovl P1, S2
cmp P2, P3
cmovle P1, P3
