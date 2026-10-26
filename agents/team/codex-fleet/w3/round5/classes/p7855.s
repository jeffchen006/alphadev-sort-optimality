# n=5 model=out iset=I1 prefix14_class=7855
mov S0, P3
cmp P0, P3
cmovle S0, P0
cmovg P3, P0
cmp P2, P1
cmovl P0, P2
cmovge P0, P1
cmovge P1, P2
cmp P0, S0
cmovle P2, P0
cmovle P0, S0
cmovl S0, P2
cmp P3, P1
cmovl P2, P3
