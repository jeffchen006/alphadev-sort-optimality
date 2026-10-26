# n=5 model=out iset=I1 prefix14_class=5880
cmp P2, P0
cmovge S2, P0
cmovg P0, P2
cmovge P2, S2
cmp P1, P3
cmovle S2, P3
cmovl P3, P1
cmovle P1, S2
cmp P1, P0
cmovge S0, P0
cmovl S0, P1
cmovge P0, P1
cmp P3, P2
cmovle P1, P3
