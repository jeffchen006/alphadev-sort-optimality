# n=5 model=out iset=I1 prefix14_class=3939
mov S0, P3
cmp P2, S0
cmovle S0, P2
cmovg P3, P2
mov P2, P1
cmp P2, P0
cmovle P1, P0
cmovg P2, P0
cmovle P0, P2
cmp S0, P2
cmovge P0, S0
cmovl P2, S0
cmp P3, P1
cmovge S0, P3
