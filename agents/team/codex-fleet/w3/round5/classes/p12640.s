# n=5 model=out iset=I1 prefix14_class=12640
cmp P3, P2
cmovge S0, P3
cmovle S0, P2
cmovl P2, P3
cmp P1, P0
cmovle P3, P1
cmovl P1, P0
cmovl P0, P3
cmovg P3, P0
cmp P2, P3
cmovle P0, P2
cmovl P2, P3
cmp P1, S0
cmovge P3, S0
