# n=5 model=out iset=I1 prefix14_class=9624
cmp P3, P1
cmovl S0, P3
cmovle P3, P1
cmovge S0, P1
cmp P0, P2
cmovl P1, P0
cmovge P1, P2
cmovl P0, P2
cmovge P2, P0
cmp P0, P3
cmovle P0, P3
cmovl P3, P2
cmp P1, S0
cmovg P0, P1
