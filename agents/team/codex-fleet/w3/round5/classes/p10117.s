# n=5 model=out iset=I1 prefix14_class=10117
cmp P1, P2
cmovge S0, P2
cmovge P2, P1
cmovl S0, P1
cmp P3, P0
cmovge P1, P3
cmovge P3, P0
cmovge P0, P1
cmovl P1, P0
cmp P2, P0
cmovle P0, P2
cmovg P1, P2
cmp S0, P3
cmovle P1, S0
